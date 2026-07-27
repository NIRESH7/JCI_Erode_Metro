import { AuthenticationFailed, NotValid } from "../../errors/ErrorConstant.js";
import { DBController } from "../../database/DbController.js";
import { authentications } from "../../utils/jwt.js";

export class MemberAuthenticate {}

MemberAuthenticate.verify = async (req, res, next) => {
  try {
    const token = req.headers.memberauthtoken;
    if (!token) throw AuthenticationFailed();

    const decoded = await authentications.verifyMemberJWT(token);
    if (!decoded?.memberId) throw AuthenticationFailed();

    const member = await DBController.Models.Member.findOne({
      where: { id: decoded.memberId, status: "active" },
    });
    if (!member) throw AuthenticationFailed();

    req.memberId = decoded.memberId;
    req.member = member;
    next();
  } catch (error) {
    next(error);
  }
};

/** After verify — blocks view-only members from write actions. */
MemberAuthenticate.requireFullAccess = async (req, res, next) => {
  try {
    const access = req.member?.app_access || "view";
    if (access !== "full") {
      throw NotValid(
        "access",
        "View only — ask admin for access to perform this action"
      );
    }
    next();
  } catch (error) {
    next(error);
  }
};
