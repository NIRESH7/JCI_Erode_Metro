import { ApplicationResponse } from "../../core/inc/response/ApplicationResponse.js";
import { ApplicationResult } from "../../core/result.js";
import { RequestAuthenticator } from "../../core/inc/request/RequestAuthenticator.js";

export class AdminAuthController {}

export const AdminAuthenticate = async (req, res, next) => {
  RequestAuthenticator.Admin.verifyAdmin(req)
    .then((data) => {
      req.token = data;
      // console.log(data);
      // if (data) {
      //   res.json({
      //     msg: data,
      //   });
      // }
      next();
    })
    .catch((error) => {
      ApplicationResponse.error(error, null, (response) => {
        res.status(response.status).json(response);
      });
    });
};

export const AdminLogin = async (req, res) => {
  RequestAuthenticator.Admin.adminLogin(req)
    .then((data) => {
      const response = ApplicationResult.forCreated();
      var statuscode = 0;
      ApplicationResponse.success(
        response,
        null,
        (response) => (statuscode = response.status)
      );
      res.json({ status: statuscode, data: data });
    })
    .catch((error) => {
      ApplicationResponse.error(error, null, (response) => {
        res.status(response.status).json(response);
      });
    });
};

export const AdminRegister = async (req, res) => {
  RequestAuthenticator.Admin.adminRegister(req)
    .then((data) => {
      const response = ApplicationResult.forCreated();
      var statuscode = 0;
      ApplicationResponse.success(
        response,
        null,
        (response) => (statuscode = response.status)
      );
      res.json({ status: statuscode, data: data });
    })
    .catch((error) => {
      ApplicationResponse.error(error, null, (response) => {
        res.status(response.status).json(response);
      });
    });
};
