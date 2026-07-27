import jwt from "jsonwebtoken";
import { jwt_admintoken, jwt_membertoken } from "../../../config/config.js";

export const authentications = {
  generateAdminJWT: async (token) => {
    try {
      return jwt.sign(token, jwt_admintoken.JWT_Adminkey, {
        algorithm: "HS256",
        expiresIn: "1d",
      });
    } catch (error) {
      return error;
    }
  },
  verifyAdminJWT: async (header) => {
    try {
      return jwt.verify(header, jwt_admintoken.JWT_Adminkey);
    } catch (error) {
      return null;
    }
  },
  generateMemberJWT: async (token) => {
    try {
      return jwt.sign(token, jwt_membertoken.JWT_Memberkey, {
        algorithm: "HS256",
        expiresIn: jwt_membertoken.JWT_MemberExpiry,
      });
    } catch (error) {
      return error;
    }
  },
  verifyMemberJWT: async (header) => {
    try {
      return jwt.verify(header, jwt_membertoken.JWT_Memberkey);
    } catch (error) {
      return null;
    }
  },
};
