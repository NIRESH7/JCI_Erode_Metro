import { DBController } from "../../database/DbController.js";
import { resolvePublicMediaUrl } from "../../utils/mediaUrl.js";

export class NotificationControl {}

NotificationControl.Member = {
  create: async ({
    memberId,
    type,
    title,
    body,
    referralId = null,
    actorMemberId = null,
  }) => {
    if (!memberId || !type || !title || !body) return null;
    return await DBController.MemberNotification.create({
      member_id: memberId,
      type,
      title,
      body,
      referral_id: referralId,
      actor_member_id: actorMemberId,
      is_read: false,
    });
  },

  list: async ({ memberId }) => {
    const rows = await DBController.MemberNotification.findForMember(memberId);
    const plain = rows.map((r) => (r.toJSON ? r.toJSON() : r));

    const actorIds = [
      ...new Set(
        plain
          .map((n) => n.actor_member_id)
          .filter((id) => id != null && id !== undefined)
      ),
    ];

    const actors = {};
    if (actorIds.length) {
      const members = await DBController.Models.Member.findAll({
        where: { id: actorIds },
        attributes: ["id", "user_name", "profile_pic"],
      });
      for (const m of members) {
        const row = m.toJSON ? m.toJSON() : m;
        actors[row.id] = {
          name: row.user_name || "",
          profile_pic: resolvePublicMediaUrl(row.profile_pic),
        };
      }
    }

    return plain.map((n) => {
      const actor = n.actor_member_id ? actors[n.actor_member_id] : null;
      return {
        ...n,
        actor_name: actor?.name || null,
        actor_profile_pic: actor?.profile_pic || null,
      };
    });
  },

  unreadCount: async ({ memberId }) => {
    const count = await DBController.MemberNotification.unreadCount(memberId);
    return { count: count || 0 };
  },

  markRead: async ({ memberId, body }) => {
    const ids = body?.ids;
    await DBController.MemberNotification.markRead(memberId, ids);
    const count = await DBController.MemberNotification.unreadCount(memberId);
    return { ok: true, count: count || 0 };
  },
};
