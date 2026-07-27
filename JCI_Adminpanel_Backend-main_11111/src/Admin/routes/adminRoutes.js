import { Router } from "express";
import { adminController } from "../controller/adminController.js";
import {
  AdminAuthenticate,
  AdminLogin,
  AdminRegister,
} from "../controller/authController.js";
import { Resizer, uploadGreenChannelPdf } from "../../core/utils/imageResizer.js";

const Adminroutes = Router();

Adminroutes.post("/register", AdminRegister);

Adminroutes.post("/login", AdminLogin);

Adminroutes.get("/getRoles", adminController.Member.getRoles);
Adminroutes.post("/createRoles", AdminAuthenticate, adminController.Member.createRoles);
Adminroutes.post("/deleteRoles", AdminAuthenticate, adminController.Member.deleteRoles);
Adminroutes.post("/changeStatus", AdminAuthenticate, adminController.Member.changesStatus);
Adminroutes.post("/changeAppAccess", AdminAuthenticate, adminController.Member.changeAppAccess);
Adminroutes.post("/getMember", AdminAuthenticate, adminController.Member.fetchMembers);
Adminroutes.post("/createMember", AdminAuthenticate, Resizer, adminController.Member.createMembers);
Adminroutes.post("/updateMember", AdminAuthenticate, Resizer, adminController.Member.updateMembers);
// Adminroutes.post("/removeMember", AdminAuthenticate, adminController.Member.removeMembers);

Adminroutes.post("/createFamily", AdminAuthenticate, adminController.Member.createFamily);


Adminroutes.post("/createDesignation", AdminAuthenticate, adminController.Member.createDesignation);
Adminroutes.post("/deleteDesignation", AdminAuthenticate, adminController.Member.deleteDesignation);

Adminroutes.post("/createEvent", AdminAuthenticate, Resizer, adminController.Member.createEvent);
Adminroutes.post("/editEvent", AdminAuthenticate, Resizer, adminController.Member.editEvent);
Adminroutes.post("/deleteEvent", AdminAuthenticate, Resizer, adminController.Member.deleteEvent);

Adminroutes.post("/createEventImage", AdminAuthenticate, Resizer, adminController.Member.createEventImage);
Adminroutes.post("/deleteEventImage", AdminAuthenticate, adminController.Member.deleteEventImage);

Adminroutes.post("/createSponser", AdminAuthenticate, Resizer, adminController.Member.createSponser);
Adminroutes.post("/editSponser", AdminAuthenticate, Resizer, adminController.Member.editSponser);
Adminroutes.post("/deleteSponser", AdminAuthenticate, adminController.Member.deleteSponser);

Adminroutes.post("/uploadGreenChannelPdf", AdminAuthenticate, uploadGreenChannelPdf, adminController.Member.uploadGreenChannelPdf);

Adminroutes.get("/getBanners", AdminAuthenticate, adminController.Member.getBanners);
Adminroutes.post("/createBanners", AdminAuthenticate, Resizer, adminController.Member.createBanners);
Adminroutes.post("/deleteBanners", AdminAuthenticate, adminController.Member.deleteBanners);

Adminroutes.post("/verifyBloodRequest", AdminAuthenticate, adminController.Member.verifyBloodRequest);
Adminroutes.get("/listRequest", AdminAuthenticate, adminController.Member.listRequest);

Adminroutes.post("/addBusinessCategory", AdminAuthenticate, adminController.Member.createBusinessCategory);
Adminroutes.post("/addBusinessSubCategory", AdminAuthenticate, adminController.Member.createBusinessSubCategory);
Adminroutes.get("/getAllBusinessName", AdminAuthenticate, adminController.Member.getAllBusinessName);

Adminroutes.post("/createNotification", adminController.Member.createNotification);
Adminroutes.get("/getAllNotification", AdminAuthenticate, adminController.Member.getNotification);
// Adminroutes.post("/getOneNotification", AdminAuthenticate, adminController.Member.getOneNotification);

Adminroutes.post("/createFolder", Resizer, adminController.Member.createFolder);
Adminroutes.get("/getallFolder", Resizer, adminController.Member.getallFolder);

export { Adminroutes };
