import { DBController } from "../../database/DbController.js";
import { FirebaseService } from "../../lib/firebase.js";
import { normalizePhone } from "../../utils/phoneUtils.js";
import { NotValid } from "../../errors/ErrorConstant.js";
import { NotificationControl } from "./NotificationControl.js";

const enrichReferral = async (referral) => {
  const plain = referral.toJSON ? referral.toJSON() : referral;
  const [referrer, linked, referred] = await Promise.all([
    DBController.Models.Member.findByPk(plain.referrer_member_id),
    plain.linked_member_id
      ? DBController.Models.Member.findByPk(plain.linked_member_id)
      : null,
    plain.referred_member_id
      ? DBController.Models.Member.findByPk(plain.referred_member_id)
      : null,
  ]);
  return {
    ...plain,
    referrer_name: referrer?.user_name,
    linked_member_name: linked?.user_name,
    referred_member_name: referred?.user_name,
  };
};

export class ReferralControl {}

ReferralControl.Referral = {
  create: async ({ body, memberId }) => {
    const referred_phone = normalizePhone(body.referred_phone);
    const referred_name = body.referred_name?.trim();
    const referral_type = body.referral_type;
    const linked_member_id = body.linked_member_id || null;
    const remark = body.remark?.trim() || null;

    if (!referred_name || !referred_phone || !referral_type) {
      throw NotValid("referral", "Name, phone and type are required");
    }
    const phoneDigits = referred_phone.replace(/\D/g, "");
    if (phoneDigits.slice(-10).length !== 10) {
      throw NotValid("referral", "Phone number must be 10 digits");
    }
    if (!linked_member_id) {
      throw NotValid("referral", "Select a member to give the connection to");
    }
    if (linked_member_id === memberId) {
      throw NotValid("referral", "You cannot give a connection to yourself");
    }

    const linkedMember = await DBController.Models.Member.findOne({
      where: { id: linked_member_id, status: "active" },
    });
    if (!linkedMember) {
      throw NotValid("referral", "Selected member not found");
    }
    if ((linkedMember.app_access || "view") !== "full") {
      throw NotValid(
        "referral",
        "You can only give referrals to members with access"
      );
    }

    let referred_member_id = null;
    const matchedMember = await DBController.MemberAuth.findMemberByPhone(
      referred_phone
    );
    if (
      matchedMember &&
      matchedMember.id !== memberId &&
      matchedMember.id !== linked_member_id
    ) {
      referred_member_id = matchedMember.id;
    }

    const referral = await DBController.Referral.create({
      referrer_member_id: memberId,
      linked_member_id,
      referral_type,
      referred_name,
      referred_phone,
      remark,
      referred_member_id,
      status: "pending",
    });

    const referrer = await DBController.Models.Member.findByPk(memberId);
    const referralId = referral?.id || referral?.dataValues?.id;
    const referrerName = referrer?.user_name || "Someone";

    if (linked_member_id) {
      await NotificationControl.Member.create({
        memberId: linked_member_id,
        type: "referral_received",
        title: "New referral for you",
        body: `${referrerName} referred ${referred_name} — tap to respond`,
        referralId,
        actorMemberId: memberId,
      });

      const fcmToken = await DBController.MemberSession.getFcmToken(
        linked_member_id
      );
      if (fcmToken) {
        await FirebaseService.notifyReferral({
          fcmToken,
          referral,
          referrerName,
          title: "New referral for you",
          body: `${referrerName} referred ${referred_name} — tap to respond`,
        });
      }
    }

    return await enrichReferral(referral);
  },

  getGiven: async ({ params }) => {
    const memberId = params.memberId;
    const list = await DBController.Referral.findGiven(memberId);
    return await Promise.all(list.map(enrichReferral));
  },

  getReceived: async ({ params, memberId }) => {
    const id = memberId || params.memberId;
    const list = await DBController.Referral.findReceived(id);
    return Promise.all(list.map(enrichReferral));
  },

  getOne: async ({ params, memberId }) => {
    const referral = await DBController.Referral.findById(params.id);
    if (!referral) throw NotValid("referral", "Referral not found");

    const plain = referral.toJSON();
    if (
      plain.referrer_member_id !== memberId &&
      plain.linked_member_id !== memberId
    ) {
      throw NotValid("referral", "Access denied");
    }

    // Linked member opened the referral → notify the referrer once.
    if (
      plain.linked_member_id === memberId &&
      plain.referrer_member_id &&
      plain.referrer_member_id !== memberId
    ) {
      const already = await DBController.MemberNotification.existsForReferralType(
        plain.referrer_member_id,
        plain.id,
        "referral_viewed"
      );
      if (!already) {
        const viewer = await DBController.Models.Member.findByPk(memberId);
        const viewerName = viewer?.user_name || "Someone";
        await NotificationControl.Member.create({
          memberId: plain.referrer_member_id,
          type: "referral_viewed",
          title: "Referral opened",
          body: `${viewerName} accessed your referral for ${plain.referred_name}`,
          referralId: plain.id,
          actorMemberId: memberId,
        });

        const referrerToken = await DBController.MemberSession.getFcmToken(
          plain.referrer_member_id
        );
        if (referrerToken) {
          await FirebaseService.notifyReferral({
            fcmToken: referrerToken,
            referral,
            referrerName: viewerName,
            title: "Referral opened",
            body: `${viewerName} accessed your referral for ${plain.referred_name}`,
          });
        }
      }
    }

    return await enrichReferral(referral);
  },

  respond: async ({ body, memberId }) => {
    const referralId = body.referral_id;
    const action = body.action;
    const connection_type = body.connection_type;
    const connect_amount = body.connect_amount;

    const referral = await DBController.Referral.findById(referralId);
    if (!referral) throw NotValid("referral", "Referral not found");

    const plain = referral.toJSON();
    if (plain.linked_member_id !== memberId) {
      throw NotValid("referral", "Only the selected member can respond");
    }
    if (plain.status !== "pending") {
      throw NotValid("referral", "Referral already responded");
    }

    if (action === "reject") {
      await DBController.Referral.update(referralId, { status: "rejected" });
    } else if (action === "accept") {
      if (!["non_closed_connect", "completed"].includes(connection_type)) {
        throw NotValid("connection", "Connection type required on accept");
      }
      const updateData = {
        status: "accepted",
        connection_type,
        connect_amount: null,
      };
      if (connection_type === "completed") {
        const amount = parseFloat(connect_amount);
        if (!connect_amount || isNaN(amount) || amount <= 0) {
          throw NotValid("amount", "Valid connect amount is required for completed");
        }
        updateData.connect_amount = amount;
      }
      await DBController.Referral.update(referralId, updateData);
    } else {
      throw NotValid("action", "Invalid action");
    }

    const updated = await DBController.Referral.findById(referralId);
    const responder = await DBController.Models.Member.findByPk(memberId);
    const responderName = responder?.user_name || "Someone";
    const statusText =
      action === "accept"
        ? connection_type === "completed"
          ? "marked as Connected"
          : "marked as Non Closed Connection"
        : "rejected";

    await NotificationControl.Member.create({
      memberId: plain.referrer_member_id,
      type: "referral_responded",
      title: "Referral update",
      body: `${responderName} ${statusText} your referral`,
      referralId: plain.id,
      actorMemberId: memberId,
    });

    const referrerToken = await DBController.MemberSession.getFcmToken(
      plain.referrer_member_id
    );
    if (referrerToken) {
      await FirebaseService.notifyReferral({
        fcmToken: referrerToken,
        referral: updated,
        referrerName: responderName,
        title: "Referral update",
        body: `${responderName} ${statusText} your referral`,
      });
    }

    return await enrichReferral(updated);
  },

  getTotalConnectAmount: async () => {
    const total = await DBController.Referral.sumConnectAmount();
    return { total: parseFloat(total) || 0 };
  },
};
