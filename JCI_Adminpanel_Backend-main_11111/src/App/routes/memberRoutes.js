import { Router } from "express";
import { MemberController } from "../controller/memberController.js";
import { MemberAuthenticate } from "../../core/inc/request/MemberAuthenticate.js";
import { Resizer } from "../../core/utils/imageResizer.js";

const memberRouter = Router();

//member routes
memberRouter.get("/allmembers", MemberController.Member.getall_Member);
memberRouter.get("/getInActiveMembers", MemberController.Member.getInActivemembers);
memberRouter.post("/member", MemberController.Member.getone_Member);
memberRouter.get("/dob", MemberController.Member.get_dob);
memberRouter.post("/family", MemberController.Member.getFamily);

memberRouter.post("/designation", MemberController.Member.getDesignation);
memberRouter.post("/roh", MemberController.Member.getRoh);

memberRouter.get("/boardmembers", MemberController.Member.getBoardmembers);
memberRouter.post("/blood_donars", MemberController.Member.getDonars);

//event routes
memberRouter.get("/allevents", MemberController.Event.getall_events);
memberRouter.get("/allevents_image", MemberController.Event.getImages);
memberRouter.post("/event", MemberController.Event.getEvent);
memberRouter.post("/event_image", MemberController.Event.getImage);

// banners
memberRouter.get("/getbanners", MemberController.Banners.getBanners);

//sponcers routes
memberRouter.post("/main_sponser", MemberController.Sponser.get_mainSponser);
memberRouter.post("/our_sponser", MemberController.Sponser.getSponser);
memberRouter.get("/greenChannel", MemberController.Member.getGreenChannelPdfs);

//blood request
memberRouter.post("/createBloodReq", MemberController.BloodReq.createBloodReq);
memberRouter.get("/getAllRequest", MemberController.BloodReq.getAllRequest);
memberRouter.get("/getOneRequest/:id", MemberController.BloodReq.getOneRequest);
memberRouter.get("/getAllFolders", MemberController.Folders.getAllFolders);

// member auth
memberRouter.post("/auth/login", MemberController.Auth.login);
memberRouter.post("/auth/lookup-phone", MemberController.Auth.lookupPhone);
memberRouter.post("/auth/setup", Resizer, MemberController.Auth.setup);
memberRouter.post("/auth/google", MemberController.Auth.google);
memberRouter.post("/auth/link-google", Resizer, MemberController.Auth.linkGoogle);
memberRouter.post("/auth/forgot-password", MemberController.Auth.forgotPassword);
memberRouter.post("/auth/verify-identity", MemberController.Auth.verifyIdentity);
memberRouter.post("/auth/reset-password", MemberController.Auth.resetPassword);
memberRouter.post("/auth/profile", MemberAuthenticate.verify, Resizer, MemberController.Auth.updateProfile);
memberRouter.get("/auth/me", MemberAuthenticate.verify, MemberController.Auth.getMe);
memberRouter.post("/session/register-token", MemberAuthenticate.verify, MemberController.Auth.registerToken);
memberRouter.get("/session/active-members", MemberAuthenticate.verify, MemberController.Auth.getActiveMembers);

// referrals
memberRouter.post(
  "/referral/create",
  MemberAuthenticate.verify,
  MemberAuthenticate.requireFullAccess,
  MemberController.Referral.create
);
memberRouter.get("/referral/given/:memberId", MemberAuthenticate.verify, MemberController.Referral.getGiven);
memberRouter.get("/referral/received", MemberAuthenticate.verify, MemberController.Referral.getReceived);
memberRouter.get("/referral/total-connect-amount", MemberAuthenticate.verify, MemberController.Referral.getTotalConnectAmount);
memberRouter.get("/referral/:id", MemberAuthenticate.verify, MemberController.Referral.getOne);
memberRouter.post(
  "/referral/respond",
  MemberAuthenticate.verify,
  MemberAuthenticate.requireFullAccess,
  MemberController.Referral.respond
);

// fitness club stories
memberRouter.post(
  "/fitness/story",
  MemberAuthenticate.verify,
  MemberAuthenticate.requireFullAccess,
  Resizer,
  MemberController.Fitness.createStory
);
memberRouter.get("/fitness/stories", MemberAuthenticate.verify, MemberController.Fitness.listStories);
memberRouter.delete("/fitness/story/:id", MemberAuthenticate.verify, MemberController.Fitness.deleteStory);


export { memberRouter };
