import { MemberControl } from "../../core/inc/controls/MemberControl.js";
import { MemberAuthControl } from "../../core/inc/controls/MemberAuthControl.js";
import { ReferralControl } from "../../core/inc/controls/ReferralControl.js";
import { FitnessControl } from "../../core/inc/controls/FitnessControl.js";
import { ApplicationResult } from "../../core/result.js";
import { ApplicationResponse } from "../../core/inc/response/ApplicationResponse.js";

const handlePromise = (promise, res, label = "Success") => {
  promise
    .then((data) => {
      const response = ApplicationResult.forCreated(label, {
        created: true,
        info: data,
      });
      ApplicationResponse.success(response, null, (response) => {
        res.status(response.status).json(response);
      });
    })
    .catch((error) => {
      ApplicationResponse.error(error, null, (response) => {
        res.status(response.status).json(response);
      });
    });
};

export class MemberController { }

MemberController.Member = {
  getall_Member: async (req, res) => {
    MemberControl.Member.fetchMember(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("All Members", {
          created: true,
          info: data,
        });
        ApplicationResponse.success(response, null, (response) => {
          res.status(response.status).json(response);
        });
      })
      .catch((error) => {
        ApplicationResponse.error(error, null, (response) => {
          res.status(response.status).json(response);
        });
      });
  },
  getInActivemembers: async (req, res) => {
    MemberControl.Member.fetchInActiveMember(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("All Members", {
          created: true,
          info: data,
        });
        ApplicationResponse.success(response, null, (response) => {
          res.status(response.status).json(response);
        });
      })
      .catch((error) => {
        ApplicationResponse.error(error, null, (response) => {
          res.status(response.status).json(response);
        });
      });
  },
  getone_Member: async (req, res) => {
    MemberControl.Member.fetchoneMember(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("Single Member", {
          created: true,
          info: data,
        });
        ApplicationResponse.success(response, null, (response) => {
          res.status(response.status).json(response);
        });
      })
      .catch((error) => {
        ApplicationResponse.error(error, null, (response) => {
          res.status(response.status).json(response);
        });
      });
  },
  get_dob: async (req, res) => {
    MemberControl.Member.fetchDob(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("Get Dob", {
          created: true,
          info: data,
        });
        ApplicationResponse.success(response, null, (response) => {
          res.status(response.status).json(response);
        });
      })
      .catch((error) => {
        ApplicationResponse.error(error, null, (response) => {
          res.status(response.status).json(response);
        });
      });
  },
  getFamily: async (req, res) => {
    MemberControl.Member.fetchFamily(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("Member's Family", {
          created: true,
          info: data,
        });
        ApplicationResponse.success(response, null, (response) => {
          res.status(response.status).json(response);
        });
      })
      .catch((error) => {
        ApplicationResponse.error(error, null, (response) => {
          res.status(response.status).json(response);
        });
      });
  },
  getDesignation: async (req, res) => {
    MemberControl.Member.fetchDesignation(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("Member's Designation", {
          created: true,
          info: data,
        });
        ApplicationResponse.success(response, null, (response) => {
          res.status(response.status).json(response);
        });
      })
      .catch((error) => {
        ApplicationResponse.error(error, null, (response) => {
          res.status(response.status).json(response);
        });
      });
  },
  getRoh: async (req, res) => {
    MemberControl.Member.fetchRoh(req)
      .then((data) => {
        const response = ApplicationResult.forCreated(
          "Member's Role of Honour",
          {
            created: true,
            info: data,
          }
        );
        ApplicationResponse.success(response, null, (response) => {
          res.status(response.status).json(response);
        });
      })
      .catch((error) => {
        ApplicationResponse.error(error, null, (response) => {
          res.status(response.status).json(response);
        });
      });
  },
  getBoardmembers: async (req, res) => {
    MemberControl.Member.fetchBoardmembers(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("Board Members", {
          created: true,
          info: data,
        });
        ApplicationResponse.success(response, null, (response) => {
          res.status(response.status).json(response);
        });
      })
      .catch((error) => {
        ApplicationResponse.error(error, null, (response) => {
          res.status(response.status).json(response);
        });
      });
  },
  getDonars: async (req, res) => {
    MemberControl.Member.fetchDonars(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("Blood BloodReq", {
          created: true,
          info: data,
        });
        ApplicationResponse.success(response, null, (response) => {
          res.status(response.status).json(response);
        });
      })
      .catch((error) => {
        console.log(error);
        ApplicationResponse.error(error, null, (response) => {
          res.status(response.status).json(response);
        });
      });
  },
  getGreenChannelPdfs: async (req, res) => {
    MemberControl.Member.fetchGreenChannelPdfs(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("Green Channel", {
          created: true,
          info: data,
        });
        ApplicationResponse.success(response, null, (response) => {
          res.status(response.status).json(response);
        });
      })
      .catch((error) => {
        ApplicationResponse.error(error, null, (response) => {
          res.status(response.status).json(response);
        });
      });
  }
};

MemberController.Event = {
  getall_events: async (req, res) => {
    MemberControl.Event.fetchallEvent(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("All Events", {
          created: true,
          info: data,
        });
        ApplicationResponse.success(response, null, (response) => {
          res.status(response.status).json(response);
        });
      })
      .catch((error) => {
        ApplicationResponse.error(error, null, (response) => {
          res.status(response.status).json(response);
        });
      });
  },
  getEvent: async (req, res) => {
    MemberControl.Event.fetchoneEvent(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("Single Event", {
          created: true,
          info: data,
        });
        ApplicationResponse.success(response, null, (response) => {
          res.status(response.status).json(response);
        });
      })
      .catch((error) => {
        ApplicationResponse.error(error, null, (response) => {
          res.status(response.status).json(response);
        });
      });
  },
  getImage: async (req, res) => {
    MemberControl.Event.fetchImage(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("Event's Image", {
          created: true,
          info: data,
        });
        ApplicationResponse.success(response, null, (response) => {
          res.status(response.status).json(response);
        });
      })
      .catch((error) => {
        ApplicationResponse.error(error, null, (response) => {
          res.status(response.status).json(response);
        });
      });
  },
  getImages: async (req, res) => {
    MemberControl.Event.fetchImages(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("Event's Image", {
          created: true,
          info: data,
        });
        ApplicationResponse.success(response, null, (response) => {
          res.status(response.status).json(response);
        });
      })
      .catch((error) => {
        ApplicationResponse.error(error, null, (response) => {
          res.status(response.status).json(response);
        });
      });
  },
};

MemberController.Banners = {
  getBanners: async (req, res) => {
    MemberControl.Banners.fetchBanners(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("Banners", {
          created: true,
          info: data,
        });
        ApplicationResponse.success(response, null, (response) => {
          res.status(response.status).json(response);
        });
      })
      .catch((error) => {
        ApplicationResponse.error(error, null, (response) => {
          res.status(response.status).json(response);
        });
      });
  },

};
MemberController.Sponser = {
  get_mainSponser: async (req, res) => {
    MemberControl.Sponser.fetch_mainSponser(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("Main Sponser", {
          created: true,
          info: data,
        });
        ApplicationResponse.success(response, null, (response) => {
          res.status(response.status).json(response);
        });
      })
      .catch((error) => {
        ApplicationResponse.error(error, null, (response) => {
          res.status(response.status).json(response);
        });
      });
  },
  getSponser: async (req, res) => {
    MemberControl.Sponser.fetchSponser(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("Sponser", {
          created: true,
          info: data,
        });
        ApplicationResponse.success(response, null, (response) => {
          res.status(response.status).json(response);
        });
      })
      .catch((error) => {
        console.log(error);
        ApplicationResponse.error(error, null, (response) => {
          res.status(response.status).json(response);
        });
      });
  },
};
MemberController.BloodReq = {
  createBloodReq: async (req, res) => {
    MemberControl.BloodReq.createBloodReq(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("BloodRequest", {
          created: true,
          info: data,
        });
        ApplicationResponse.success(response, null, (response) => {
          res.status(response.status).json(response);
        });
      })
      .catch((error) => {
        ApplicationResponse.error(error, null, (response) => {
          res.status(response.status).json(response);
        });
      });
  },
  getAllRequest: async (req, res) => {
    MemberControl.BloodReq.getAllRequest(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("BloodRequest", {
          created: true,
          info: data,
        });
        ApplicationResponse.success(response, null, (response) => {
          res.status(response.status).json(response);
        });
      })
      .catch((error) => {
        ApplicationResponse.error(error, null, (response) => {
          res.status(response.status).json(response);
        });
      });
  },
  getOneRequest: async (req, res) => {
    MemberControl.BloodReq.getOneRequest(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("BloodRequest", {
          created: true,
          info: data,
        });
        ApplicationResponse.success(response, null, (response) => {
          res.status(response.status).json(response);
        });
      })
      .catch((error) => {
        ApplicationResponse.error(error, null, (response) => {
          res.status(response.status).json(response);
        });
      });
  },
};
MemberController.Folders = {
  getAllFolders: async (req, res) => {
    MemberControl.Folders.fetchedFolders(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("Folders", {
          created: true,
          info: data,
        });
        ApplicationResponse.success(response, null, (response) => {
          res.status(response.status).json(response);
        });
      })
      .catch((error) => {
        ApplicationResponse.error(error, null, (response) => {
          res.status(response.status).json(response);
        });
      });
  },

};

MemberController.Auth = {
  login: (req, res) => handlePromise(MemberAuthControl.Auth.login(req), res, "Login"),
  lookupPhone: (req, res) =>
    handlePromise(MemberAuthControl.Auth.lookupPhone(req), res, "LookupPhone"),
  setup: (req, res) => handlePromise(MemberAuthControl.Auth.setup(req), res, "Setup"),
  google: (req, res) => handlePromise(MemberAuthControl.Auth.google(req), res, "Google"),
  linkGoogle: (req, res) => handlePromise(MemberAuthControl.Auth.linkGoogle(req), res, "LinkGoogle"),
  forgotPassword: (req, res) => handlePromise(MemberAuthControl.Auth.forgotPassword(req), res, "ForgotPassword"),
  verifyIdentity: (req, res) => handlePromise(MemberAuthControl.Auth.verifyIdentity(req), res, "VerifyIdentity"),
  resetPassword: (req, res) => handlePromise(MemberAuthControl.Auth.resetPassword(req), res, "ResetPassword"),
  updateProfile: (req, res) =>
    handlePromise(
      MemberAuthControl.Auth.updateProfile({
        body: req.body,
        memberId: req.memberId,
        image: req.image,
      }),
      res,
      "UpdateProfile"
    ),
  registerToken: (req, res) =>
    handlePromise(
      MemberAuthControl.Auth.registerToken({ body: req.body, memberId: req.memberId }),
      res,
      "RegisterToken"
    ),
  getActiveMembers: (req, res) =>
    handlePromise(MemberAuthControl.Auth.getActiveMembers(), res, "ActiveMembers"),
  getMe: (req, res) =>
    handlePromise(
      MemberAuthControl.Auth.getMe({ memberId: req.memberId }),
      res,
      "Me"
    ),
};

MemberController.Referral = {
  create: (req, res) =>
    handlePromise(ReferralControl.Referral.create({ body: req.body, memberId: req.memberId }), res, "Referral"),
  getGiven: (req, res) => handlePromise(ReferralControl.Referral.getGiven(req), res, "ReferralGiven"),
  getReceived: (req, res) =>
    handlePromise(
      ReferralControl.Referral.getReceived({ params: req.params, memberId: req.memberId }),
      res,
      "ReferralReceived"
    ),
  getTotalConnectAmount: (req, res) =>
    handlePromise(ReferralControl.Referral.getTotalConnectAmount(), res, "ReferralTotal"),
  getOne: (req, res) =>
    handlePromise(ReferralControl.Referral.getOne({ params: req.params, memberId: req.memberId }), res, "Referral"),
  respond: (req, res) =>
    handlePromise(ReferralControl.Referral.respond({ body: req.body, memberId: req.memberId }), res, "ReferralRespond"),
};

MemberController.Fitness = {
  createStory: (req, res) =>
    handlePromise(
      FitnessControl.Story.create({ memberId: req.memberId, imagePath: req.image }),
      res,
      "FitnessStory"
    ),
  listStories: (req, res) =>
    handlePromise(FitnessControl.Story.listActive(), res, "FitnessStories"),
  deleteStory: (req, res) =>
    handlePromise(
      FitnessControl.Story.deleteOwn({ storyId: parseInt(req.params.id, 10), memberId: req.memberId }),
      res,
      "FitnessStoryDelete"
    ),
};