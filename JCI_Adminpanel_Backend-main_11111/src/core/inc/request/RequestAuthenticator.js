import require from "requirejs";
const bcrypt = require("bcrypt");
import {AuthenticationFailed} from "../../errors/ErrorConstant.js";
import { DBController } from "../../database/DbController.js";
import { authentications } from "../../utils/jwt.js";

export class RequestAuthenticator {}

RequestAuthenticator.Admin = {
  verifyAdmin: async ({ headers }) => {
    var isMalicious = true;
    if (headers.hasOwnProperty("adminauthtoken")) {
      
      const decoded = await authentications.verifyAdminJWT(headers.adminauthtoken);

      if (decoded != null &&decoded != undefined &&decoded.user_type == "ROOT" &&decoded.status == "active") {

        const foundAdmin = await DBController.Models.Admin.findOne({
          where: {
            id: decoded.userId,
            user_type: "ROOT",
            status: "active",
          },
        });
        if (foundAdmin == null || foundAdmin == undefined) {
          throw AuthenticationFailed();
        } 
        else {
          return "Valid User";
        }
      }else{
        throw AuthenticationFailed();
      }
    } 
    else if (isMalicious) {
      throw AuthenticationFailed();
    } else {
      return "Try Again Later";
    }
  },
  adminLogin: async ({ body }) => {
    
    body.login = body.login?.trim() || null;
    body.password = body.password?.trim() || null;
    if (!body.login || !body.password) {
      return "User Login should not be Null";
    } else {
      const adminFound = await DBController.Admin.Auth.signin(body);
      // console.log(adminFound);
      if (adminFound == null) {
        return "No Admin Found";
      } else {
        if (adminFound.status === "terminated") {
          return "You have been Terminated";
        } else if (
          adminFound.status === "active" &&
          adminFound.user_type === "ROOT"
        ) {
          try {
            // console.log(await bcrypt.compare(body.password, adminFound.password))
            if (await bcrypt.compare(body.password, adminFound.password)) {
              return {
                token: await authentications.generateAdminJWT({
                  userId: adminFound.id,
                  status: adminFound.status,
                  user_type: adminFound.user_type,
                }),
              };
            } else {
              return "Wrong Email/Password. Try Again!";
            }
          } catch (error) {
            return null;
          }
        } else {
          return "Verify Account";
        }
      }
    }
  },
  adminRegister: async ({ body }) => {
    // console.log(body,"body")
    const accoundFound = await DBController.Admin.Auth.checkAdminExists(body);
    if (accoundFound != null && accoundFound != undefined) {
      return "User Already Exists";
    } else {
      // console.log(body,"sada")
      const created = await DBController.Admin.Auth.signup(body);
      if (created != null && created != undefined) {
        return "Account Created";
      } else {
        return "Error";
      }
    }
  },
};
