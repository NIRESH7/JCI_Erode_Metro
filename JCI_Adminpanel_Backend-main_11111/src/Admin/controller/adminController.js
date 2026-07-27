import { AdminControl } from "../../core/inc/controls/AdminControl.js";
import { ApplicationResponse } from "../../core/inc/response/ApplicationResponse.js";
import { ApplicationResult } from "../../core/result.js";

export class adminController { }

adminController.Member = {
  fetchMembers: async (req, res) => {
    AdminControl.Member.getMember(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("Members fetched", {
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
  createMembers: async (req, res) => {
    AdminControl.Member.addMember(req)
      .then((data) => {
        console.log("data", data);
        const response = ApplicationResult.forCreated("Members Created", {
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
  updateMembers: async (req, res) => {
    AdminControl.Member.updateMember(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("Members Updated", {
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
  // removeMembers: async (req, res) => {
  //   AdminControl.Member.deleteMember(req)
  //     .then((data) => {
  //       const response = ApplicationResult.forCreated("Members Created", {
  //         created: true,
  //         info: data,
  //       });
  //       ApplicationResponse.success(response, null, (response) => {
  //         res.status(response.status).json(response);
  //       });
  //     })
  //     .catch((error) => {
  //       ApplicationResponse.error(error, null, (response) => {
  //         res.status(response.status).json(response);
  //       });
  //     });
  // },
  createFamily: async (req, res) => {

    AdminControl.Member.addFamily(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("Family Created", {
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
  changesStatus: async (req, res) => {
    AdminControl.Member.changesStatus(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("Member Active successfully", {
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
  changeAppAccess: async (req, res) => {
    AdminControl.Member.changeAppAccess(req)
      .then((data) => {
        const response = ApplicationResult.forCreated(data, {
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
  createEvent: async (req, res) => {
    AdminControl.Member.addEvent(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("Events Created", {
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
  editEvent: async (req, res) => {
    AdminControl.Member.updateEvent(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("Event Updated", {
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
  deleteEvent: async (req, res) => {
    AdminControl.Member.removeEvent(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("Event Deleted", {
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
  createEventImage: async (req, res, files) => {
    AdminControl.Member.addImage(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("Event Image Created", {
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
  deleteEventImage: async (req, res) => {
    AdminControl.Member.deleteImage(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("Event Image Deleted", {
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
  createSponser: async (req, res) => {
    AdminControl.Member.addSponser(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("Sponser Created", {
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
  editSponser: async (req, res) => {
    AdminControl.Member.updateSponser(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("Sponser Created", {
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
  deleteSponser: async (req, res) => {
    AdminControl.Member.removeSponser(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("Sponser Deleted", {
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

  createDesignation: async (req, res) => {
    AdminControl.Member.addDesignation(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("Designation Created", {
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
  deleteDesignation: async (req, res) => {
    AdminControl.Member.removeDesignation(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("Designation Deleted", {
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
  createRoles: async (req, res) => {
    AdminControl.Member.addRoles(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("Role Created", {
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
  deleteRoles: async (req, res) => {
    AdminControl.Member.destroyrole(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("Role Deleted", {
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
  getRoles: async (req, res) => {
    AdminControl.Member.fetchRoles(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("Role Fetched", {
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
  uploadGreenChannelPdf: async (req, res) => {
    AdminControl.Member.uploadGreenChannelPdf(req)
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
  },
  getBanners: async (req, res) => {
    AdminControl.Member.fetchBanners(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("Banners Fetched", {
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
  createBanners: async (req, res) => {
    AdminControl.Member.createBanners(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("Banner Created", {
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
  deleteBanners: async (req, res) => {
    AdminControl.Member.deleteBanners(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("Banner Deleted", {
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
  listRequest: async (req, res) => {
    AdminControl.Member.fetchedRequests(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("Blood Request Fetched", {
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
  verifyBloodRequest: async (req, res) => {
    AdminControl.Member.verifyBloodRequest(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("Verify Blood Request", {
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

  createBusinessCategory: async (req, res) => {
    AdminControl.Member.createBusinessCategory(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("Business Category Created", {
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
  createBusinessSubCategory: async (req, res) => {
    AdminControl.Member.createBusinessSubCategory(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("Business SubCategory Created", {
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
  getAllBusinessName: async (req, res) => {
    AdminControl.Member.fetchedBusinessName(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("Bussiness Name Fetched", {
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
  createNotification: async (req, res) => {
    AdminControl.Member.createNotification(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("Notification Created", {
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
  getNotification: async (req, res) => {
    AdminControl.Member.getNotification(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("Notification Fetched", {
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
  getOneNotification: async (req, res) => {
    AdminControl.Member.getOneNotification(req)
      .then((data) => {
        const response = ApplicationResult.forCreated("Notification Fetched", {
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
  createFolder: async (req, res) => {
    AdminControl.Member.createFolder(req)
      .then((data) => {
        const response = ApplicationResult.forCreated(" Image Folder Created", {
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
  getallFolder: async (req, res) => {
    AdminControl.Member.getallFolder(req)
      .then((data) => {
        const response = ApplicationResult.forCreated(" Image Folder Created", {
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
