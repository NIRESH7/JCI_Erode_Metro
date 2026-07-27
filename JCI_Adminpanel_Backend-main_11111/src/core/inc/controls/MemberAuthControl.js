import bcrypt from "bcrypt";
import crypto from "crypto";
import got from "got";
import { DBController } from "../../database/DbController.js";
import { authentications } from "../../utils/jwt.js";
import { MailerService } from "../../utils/mailer.js";
import { normalizePhone, phonesMatch } from "../../utils/phoneUtils.js";
import { google_config } from "../../../../config/config.js";
import { NotValid, AuthenticationFailed } from "../../errors/ErrorConstant.js";

const hashToken = (token) =>
  crypto.createHash("sha256").update(token).digest("hex");

const buildAuthResponse = async (member, auth) => {
  const token = await authentications.generateMemberJWT({
    memberId: member.id,
    status: member.status,
    app_access: member.app_access || "view",
  });
  return {
    token,
    member: {
      id: member.id,
      user_name: member.user_name,
      email: member.email,
      contact: member.contact,
      profile_pic: member.profile_pic,
      membership_id: member.membership_id,
      gender: member.gender,
      dob: member.dob,
      location: member.location,
      blood_group: member.blood_group,
      willing_to_donate: member.willing_to_donate,
      office_name: member.office_name,
      sector: member.sector,
      job: member.job,
      martial_status: member.martial_status,
      role: member.role,
      jci_location: member.jci_location,
      type: member.type,
      app_access: member.app_access || "view",
      is_setup_complete: auth?.is_setup_complete ?? true,
    },
  };
};

const getMemberOrThrow = async (memberId) => {
  const member = await DBController.Models.Member.findOne({
    where: { id: memberId, status: "active" },
  });
  if (!member) throw NotValid("member", "Member not found or inactive");
  return member;
};

const resolveGoogleIdentity = async (body) => {
  const idToken = body.id_token?.trim();
  if (idToken) {
    let payload;
    try {
      payload = await got(
        `https://oauth2.googleapis.com/tokeninfo?id_token=${idToken}`
      ).json();
    } catch {
      throw AuthenticationFailed();
    }
    const allowed = [google_config.clientId, google_config.webClientId].filter(
      Boolean
    );
    if (allowed.length && !allowed.includes(payload.aud)) {
      throw AuthenticationFailed();
    }
    return {
      email: payload.email?.toLowerCase(),
      googleId: payload.sub,
    };
  }

  const accessToken = body.access_token?.trim();
  const clientEmail = body.email?.trim().toLowerCase();
  const clientGoogleId = body.google_id?.trim();

  if (accessToken) {
    const endpoints = [
      () =>
        got("https://www.googleapis.com/oauth2/v3/userinfo", {
          headers: { Authorization: `Bearer ${accessToken}` },
        }).json(),
      () =>
        got(
          `https://www.googleapis.com/oauth2/v1/userinfo?access_token=${accessToken}`
        ).json(),
      () =>
        got(
          `https://oauth2.googleapis.com/tokeninfo?access_token=${accessToken}`
        ).json(),
    ];

    let userInfo;
    for (const fetchInfo of endpoints) {
      try {
        userInfo = await fetchInfo();
        break;
      } catch {
        // try next Google endpoint
      }
    }

    if (!userInfo) throw AuthenticationFailed();

    const email = userInfo.email?.toLowerCase() || clientEmail;
    const googleId = userInfo.sub || userInfo.user_id || clientGoogleId;

    if (!email || !googleId) throw AuthenticationFailed();

    if (userInfo?.email && clientEmail && userInfo.email.toLowerCase() !== clientEmail) {
      throw AuthenticationFailed();
    }
    if (
      (userInfo?.sub || userInfo?.user_id) &&
      clientGoogleId &&
      (userInfo.sub || userInfo.user_id) !== clientGoogleId
    ) {
      throw AuthenticationFailed();
    }

    return { email, googleId };
  }

  throw NotValid("google", "Google token required");
};

const resolveMemberByUserName = async ({
  user_name,
  verify_phone,
  verify_email,
  requirePhone = false,
}) => {
  const userName = user_name?.trim();
  if (!userName) throw NotValid("user_name", "Your name is required");

  const matches = await DBController.MemberAuth.findMembersByName(userName);
  if (!matches.length) {
    throw NotValid("user_name", "No member found with this name");
  }

  const verifyPhone = verify_phone?.trim();
  if (requirePhone || verifyPhone) {
    if (!verifyPhone) throw NotValid("verify", "Phone is required");
    const phoneMatches = matches.filter((m) =>
      phonesMatch(m.contact, verifyPhone)
    );
    if (phoneMatches.length === 1) return phoneMatches[0];
    if (phoneMatches.length === 0) {
      throw NotValid("verify", "Name and phone do not match our records");
    }
    throw NotValid("verify", "Multiple members match — contact admin");
  }

  const verifyEmail = verify_email?.trim()?.toLowerCase();
  if (verifyEmail) {
    const emailMatches = matches.filter(
      (m) => m.email?.toLowerCase() === verifyEmail
    );
    if (emailMatches.length === 1) return emailMatches[0];
    if (emailMatches.length === 0) {
      throw NotValid("verify", "Name and email do not match our records");
    }
    throw NotValid("verify", "Multiple members match — contact admin");
  }

  throw NotValid("verify", "Phone or email verification required");
};

const GENDERS = ["male", "female", "others"];
const BLOOD_GROUPS = [
  "O+",
  "O-",
  "A+",
  "A-",
  "B+",
  "B-",
  "AB+",
  "AB-",
  "A1+",
  "A2+",
  "A1B+",
  "A1B-",
  "A2B+",
  "HH",
];

const formatContact = (phone) => {
  const normalized = normalizePhone(phone);
  if (!normalized) return null;
  const digits = normalized.replace(/\D/g, "");
  const last10 = digits.slice(-10);
  if (last10.length !== 10) return null;
  return `+91${last10}`;
};

/** Parse + validate complete-profile fields from setup / link-google. */
const parseCompleteProfile = (body, { requirePhoto, image }) => {
  const user_name = body.user_name?.trim();
  const email =
    body.email?.trim()?.toLowerCase() ||
    body.verify_email?.trim()?.toLowerCase();
  const password = body.password?.trim();
  const contactRaw = body.phone?.trim() || body.contact?.trim() || body.verify_phone?.trim();
  const gender = body.gender?.trim()?.toLowerCase();
  const dob = body.dob?.trim();
  const blood_group = body.blood_group?.trim();
  const location = body.location?.trim() || body.address?.trim();
  const profile_pic =
    image ||
    body.google_photo_url?.trim() ||
    body.profile_pic?.trim() ||
    null;

  if (!user_name) throw NotValid("user_name", "Name is required");
  if (!email) throw NotValid("email", "Email is required");
  if (!password || password.length < 6) {
    throw NotValid("password", "Password (min 6 chars) required");
  }
  const contact = formatContact(contactRaw);
  if (!contact) {
    throw NotValid("contact", "Valid 10-digit phone number is required");
  }
  if (!gender || !GENDERS.includes(gender)) {
    throw NotValid("gender", "Gender is required (male, female, or others)");
  }
  if (!dob) throw NotValid("dob", "Date of birth is required");
  if (!blood_group || !BLOOD_GROUPS.includes(blood_group)) {
    throw NotValid("blood_group", "Valid blood group is required");
  }
  if (!location) throw NotValid("location", "Communication address is required");
  if (requirePhoto && !profile_pic) {
    throw NotValid("profile_pic", "Profile picture is required");
  }

  const willing = body.willing_to_donate?.trim()?.toLowerCase();
  const board = body.board_member?.trim()?.toLowerCase() || body.type?.trim()?.toLowerCase();
  let type = "member";
  if (board === "yes" || board === "boardmember") type = "boardmember";
  if (board === "no" || board === "member") type = "member";

  const fields = {
    user_name,
    email,
    contact,
    gender,
    dob,
    blood_group,
    location,
    type,
    status: "active",
    app_access: "view",
    willing_to_donate:
      willing === "yes" || willing === "no" ? willing : "no",
    office_name: body.office_name?.trim() || body.company_name?.trim() || null,
    sector: body.sector?.trim() || body.business_category?.trim() || null,
    job: body.job?.trim() || body.designation?.trim() || null,
    martial_status: body.martial_status?.trim() || body.marital_status?.trim() || null,
    role: null,
    jci_location: body.jci_location?.trim() || null,
  };
  if (profile_pic) fields.profile_pic = profile_pic;

  return { fields, password, email, user_name };
};

/** Profile update from app — email is not editable. */
const parseProfileUpdate = (body, image, existingMember) => {
  const user_name = body.user_name?.trim();
  if (!user_name) throw NotValid("user_name", "Name is required");

  const contactRaw = body.phone?.trim() || body.contact?.trim();
  let contact = existingMember.contact;
  if (contactRaw) {
    contact = formatContact(contactRaw);
    if (!contact) throw NotValid("contact", "Valid 10-digit phone required");
  }

  const gender = body.gender?.trim()?.toLowerCase() || existingMember.gender;
  const dob = body.dob?.trim() || existingMember.dob;
  const blood_group = body.blood_group?.trim() || existingMember.blood_group;
  const location =
    body.location?.trim() || body.address?.trim() || existingMember.location;

  if (gender && !GENDERS.includes(gender)) {
    throw NotValid("gender", "Invalid gender");
  }
  if (blood_group && !BLOOD_GROUPS.includes(blood_group)) {
    throw NotValid("blood_group", "Invalid blood group");
  }

  const willing = body.willing_to_donate?.trim()?.toLowerCase();
  const board =
    body.board_member?.trim()?.toLowerCase() || body.type?.trim()?.toLowerCase();
  let type = existingMember.type || "member";
  if (board === "yes" || board === "boardmember") type = "boardmember";
  if (board === "no" || board === "member") type = "member";

  const fields = {
    user_name,
    contact,
    gender,
    dob,
    blood_group,
    location,
    type,
    willing_to_donate:
      willing === "yes" || willing === "no"
        ? willing
        : existingMember.willing_to_donate,
    office_name:
      body.office_name?.trim() ||
      body.company_name?.trim() ||
      existingMember.office_name,
    sector:
      body.sector?.trim() ||
      body.business_category?.trim() ||
      existingMember.sector,
    job:
      body.job?.trim() || body.designation?.trim() || existingMember.job,
    martial_status:
      body.martial_status?.trim() ||
      body.marital_status?.trim() ||
      existingMember.martial_status,
    jci_location: body.jci_location?.trim() || existingMember.jci_location,
  };

  if (body.membership_id !== undefined) {
    fields.membership_id = body.membership_id?.trim() || null;
  }
  if (image) fields.profile_pic = image;

  return fields;
};

const upsertMemberProfile = async (fields) => {
  const emailLower = fields.email?.trim()?.toLowerCase();
  let member = await DBController.MemberAuth.findMemberByEmail(emailLower);
  if (member) {
    await member.update(fields);
    return member;
  }
  return await DBController.Models.Member.create(fields);
};

const buildMemberSnapshot = (member) => ({
  id: member.id,
  user_name: member.user_name,
  email: member.email,
  contact: member.contact,
  membership_id: member.membership_id,
  gender: member.gender,
  dob: member.dob,
  location: member.location,
  blood_group: member.blood_group,
  willing_to_donate: member.willing_to_donate,
  office_name: member.office_name,
  sector: member.sector,
  job: member.job,
  martial_status: member.martial_status,
  role: member.role,
  jci_location: member.jci_location,
  type: member.type,
  profile_pic: member.profile_pic,
  app_access: member.app_access || "view",
});

const createOrUpdateMemberAuth = async (memberId, member, password, extra = {}) => {
  const existing = await DBController.MemberAuth.findByMemberId(memberId);
  const password_hash = await bcrypt.hash(password, 10);
  const authData = {
    password_hash,
    login_email: member.email?.toLowerCase() || null,
    login_phone: normalizePhone(member.contact),
    is_setup_complete: true,
    ...extra,
  };

  if (existing) {
    await DBController.MemberAuth.updateAuth(memberId, authData);
  } else {
    await DBController.MemberAuth.createAuth({
      member_id: memberId,
      ...authData,
    });
  }

  return await DBController.MemberAuth.findByMemberId(memberId);
};

export class MemberAuthControl {}

MemberAuthControl.Auth = {
  login: async ({ body }) => {
    const login = body.login?.trim();
    const password = body.password?.trim();
    if (!login || !password) throw NotValid("login", "Login and password required");

    const auth = await DBController.MemberAuth.findByEmailOrPhone(login);
    if (!auth) {
      throw NotValid("login", "No account found with this email or phone");
    }
    if (!auth.password_hash) {
      if (auth.google_id) {
        throw NotValid(
          "login",
          "This account uses Google Sign-In. Tap Continue with Google, or use Forgot password to set a password."
        );
      }
      throw NotValid(
        "login",
        "Account setup is incomplete. Use Set up your account or Continue with Google."
      );
    }

    const valid = await bcrypt.compare(password, auth.password_hash);
    if (!valid) throw NotValid("login", "Incorrect password");

    const member = await getMemberOrThrow(auth.member_id);
    return await buildAuthResponse(member, auth);
  },

  setup: async ({ body, image }) => {
    let memberId = body.member_id ? Number(body.member_id) : null;
    const contactRaw =
      body.phone?.trim() || body.contact?.trim() || body.verify_phone?.trim();

    if (body.batch_activate === "true" || body.batch_activate === true) {
      const password = body.password?.trim();
      if (!memberId) throw NotValid("member_id", "Member id required");
      if (!password || password.length < 6) {
        throw NotValid("password", "Password (min 6 chars) required");
      }
      const contact = formatContact(contactRaw);
      if (!contact) {
        throw NotValid("contact", "Valid 10-digit phone number is required");
      }

      const member = await getMemberOrThrow(memberId);
      if (!phonesMatch(member.contact, contactRaw)) {
        throw NotValid("phone", "Phone does not match member records");
      }

      const existing = await DBController.MemberAuth.findByMemberId(memberId);
      if (existing?.is_setup_complete && (existing.password_hash || existing.google_id)) {
        throw NotValid("auth", "Account already exists. Please sign in.");
      }

      const auth = await createOrUpdateMemberAuth(memberId, member, password);
      return await buildAuthResponse(member, auth);
    }

    if (!memberId && contactRaw) {
      const byPhone = await DBController.MemberAuth.findMemberByPhone(contactRaw);
      if (byPhone) memberId = byPhone.id;
    }

    const existingMember = memberId ? await getMemberOrThrow(memberId) : null;
    const requirePhoto = !existingMember?.profile_pic;
    const { fields, password } = parseCompleteProfile(body, {
      requirePhoto,
      image,
    });

    let member;
    if (memberId) {
      member = existingMember;
      await member.update(fields);
    } else {
      member = await upsertMemberProfile(fields);
      memberId = member.id;
    }

    const auth = await createOrUpdateMemberAuth(memberId, member, password);
    return await buildAuthResponse(member, auth);
  },

  google: async ({ body }) => {
    const { email, googleId } = await resolveGoogleIdentity(body);
    if (!email || !googleId) throw AuthenticationFailed();

    let auth = await DBController.MemberAuth.findByGoogleId(googleId);
    if (!auth) {
      const member = await DBController.MemberAuth.findMemberByEmail(email);
      if (!member) {
        return { needs_setup: true, email, google_id: googleId };
      }
      auth = await DBController.MemberAuth.findByMemberId(member.id);
      if (auth) {
        await DBController.MemberAuth.updateAuth(member.id, {
          google_id: googleId,
          login_email: email,
          is_setup_complete: true,
        });
      } else {
        await DBController.MemberAuth.createAuth({
          member_id: member.id,
          google_id: googleId,
          login_email: email,
          login_phone: normalizePhone(member.contact),
          is_setup_complete: true,
        });
      }
      auth = await DBController.MemberAuth.findByMemberId(member.id);
    }

    const member = await getMemberOrThrow(auth.member_id);
    return await buildAuthResponse(member, auth);
  },

  linkGoogle: async ({ body, image }) => {
    const googleId = body.google_id?.trim();
    if (!googleId) throw NotValid("google", "Google sign-in required");

    const { fields, password } = parseCompleteProfile(body, {
      requirePhoto: true,
      image,
    });
    let memberId = body.member_id;

    let member;
    const existingGoogle = await DBController.MemberAuth.findByGoogleId(googleId);
    if (existingGoogle) {
      member = await getMemberOrThrow(existingGoogle.member_id);
      await member.update(fields);
      memberId = member.id;
    } else if (memberId) {
      member = await getMemberOrThrow(memberId);
      await member.update(fields);
    } else {
      member = await upsertMemberProfile(fields);
      memberId = member.id;
    }

    const existing = await DBController.MemberAuth.findByMemberId(memberId);
    const password_hash = await bcrypt.hash(password, 10);
    const data = {
      google_id: googleId,
      password_hash,
      login_email: member.email?.toLowerCase() || null,
      login_phone: normalizePhone(member.contact),
      is_setup_complete: true,
    };
    if (existing) {
      await DBController.MemberAuth.updateAuth(memberId, data);
    } else {
      await DBController.MemberAuth.createAuth({ member_id: memberId, ...data });
    }
    const auth = await DBController.MemberAuth.findByMemberId(memberId);
    return await buildAuthResponse(member, auth);
  },

  forgotPassword: async ({ body }) => {
    const email = body.email?.trim()?.toLowerCase();
    if (!email) throw NotValid("email", "Email required");

    const member = await DBController.MemberAuth.findMemberByEmail(email);
    if (!member) throw NotValid("email", "No member found with this email");

    const auth = await DBController.MemberAuth.findByMemberId(member.id);
    if (!auth) throw NotValid("auth", "Account not set up yet");

    const resetToken = crypto.randomBytes(4).toString("hex").toUpperCase();
    const expires = new Date();
    expires.setHours(expires.getHours() + 1);

    await DBController.MemberAuth.createResetToken({
      member_id: member.id,
      token_hash: hashToken(resetToken),
      type: "email_link",
      expires_at: expires,
      used: false,
    });

    const mailResult = await MailerService.sendPasswordResetEmail({
      to: email,
      resetToken,
      memberName: member.user_name,
    });

    return {
      message: mailResult.sent
        ? "Reset code sent to your email"
        : "Reset code generated (check server logs if SMTP not configured)",
      ...(process.env.HS_NODE_ENV === "development" && !mailResult.sent
        ? { dev_reset_code: resetToken }
        : {}),
    };
  },

  lookupPhone: async ({ body }) => {
    const phone = body.phone?.trim();
    if (!phone) throw NotValid("phone", "Phone number required");

    const member = await DBController.MemberAuth.findMemberByPhone(phone);
    if (!member) {
      return { found: false };
    }

    const auth = await DBController.MemberAuth.findByMemberId(member.id);
    const hasAuth = !!(
      auth?.is_setup_complete && (auth.password_hash || auth.google_id)
    );

    return {
      found: true,
      has_auth: hasAuth,
      member: buildMemberSnapshot(member),
    };
  },

  verifyIdentity: async ({ body }) => {
    const phone = body.phone?.trim();
    const userName = body.user_name?.trim()?.toLowerCase();
    const dob = body.dob?.trim();

    if (!phone || !userName || !dob) {
      throw NotValid("identity", "Phone, name and DOB required");
    }

    const member = await DBController.MemberAuth.findMemberByPhone(phone);
    if (
      !member ||
      member.user_name?.toLowerCase() !== userName ||
      member.dob !== dob
    ) {
      throw NotValid("identity", "Details do not match our records");
    }

    const sessionToken = crypto.randomBytes(16).toString("hex");
    const expires = new Date();
    expires.setMinutes(expires.getMinutes() + 15);

    await DBController.MemberAuth.createResetToken({
      member_id: member.id,
      token_hash: hashToken(sessionToken),
      type: "identity_verify",
      expires_at: expires,
      used: false,
    });

    return { reset_session: sessionToken, member_id: member.id };
  },

  resetPassword: async ({ body }) => {
    let memberId = body.member_id;
    const email = body.email?.trim()?.toLowerCase();
    const resetToken = body.reset_token?.trim()?.toUpperCase();
    const newPassword = body.new_password?.trim();

    if (!resetToken || !newPassword || newPassword.length < 6) {
      throw NotValid("reset", "Reset code and new password (min 6) required");
    }

    if (!memberId && email) {
      const member = await DBController.MemberAuth.findMemberByEmail(email);
      if (!member) throw NotValid("email", "No member found with this email");
      memberId = member.id;
    }
    if (!memberId) throw NotValid("email", "Email is required");

    const tokenRecord = await DBController.MemberAuth.findValidResetToken(
      memberId,
      hashToken(resetToken)
    );
    if (!tokenRecord) throw NotValid("token", "Invalid or expired reset code");

    const password_hash = await bcrypt.hash(newPassword, 10);
    await DBController.MemberAuth.updateAuth(memberId, {
      password_hash,
      is_setup_complete: true,
    });
    await DBController.MemberAuth.markResetTokenUsed(tokenRecord.id);

    const member = await getMemberOrThrow(memberId);
    const auth = await DBController.MemberAuth.findByMemberId(memberId);
    return await buildAuthResponse(member, auth);
  },

  registerToken: async ({ body, memberId }) => {
    const fcm_token = body.fcm_token?.trim();
    await DBController.MemberSession.upsertSession({
      member_id: memberId,
      fcm_token,
      device_info: body.device_info || null,
    });
    return "Token registered";
  },

  getActiveMembers: async () => {
    return await DBController.MemberSession.getActiveMembers();
  },

  /** Fresh profile (incl. app_access) without requiring re-login. */
  getMe: async ({ memberId }) => {
    const member = await DBController.Models.Member.findOne({
      where: { id: memberId, status: "active" },
      raw: true,
    });
    if (!member) throw NotValid("member", "Member not found or inactive");
    const auth = await DBController.MemberAuth.findByMemberId(memberId);
    return await buildAuthResponse(member, auth);
  },

  updateProfile: async ({ body, memberId, image }) => {
    const member = await getMemberOrThrow(memberId);
    const fields = parseProfileUpdate(body, image, member);
    await member.update(fields);

    const auth = await DBController.MemberAuth.findByMemberId(memberId);
    if (auth && fields.contact) {
      await DBController.MemberAuth.updateAuth(memberId, {
        login_phone: normalizePhone(fields.contact),
      });
    }

    const updatedMember = await getMemberOrThrow(memberId);
    const updatedAuth = await DBController.MemberAuth.findByMemberId(memberId);
    return await buildAuthResponse(updatedMember, updatedAuth);
  },
};
