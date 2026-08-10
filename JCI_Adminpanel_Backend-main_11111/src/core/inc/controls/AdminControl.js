import capitalize from "lodash/capitalize.js";
import { DBController } from "../../database/DbController.js";

import {
  AlreadyExists,
  CustomError,
  MemberExists,
  SomethingWentWrong,
} from "../../errors/ErrorConstant.js";
import { FirebaseService } from "../../lib/firebase.js";
import { convert24HrTo12Hr, validDateFormat } from "../../utils/moment.js";
import moment from "moment";
import { mapMediaFields } from "../../utils/mediaUrl.js";

export class AdminControl { }

AdminControl.Member = {
  getMember: async ({ body }) => {
    const fetched = await DBController.Admin.Create.fetchMember(body);
    // console.log("🚀 ~ getMember: ~ fetched:", fetched)
    if (fetched != null && fetched != undefined && fetched != 0) {
      return mapMediaFields(fetched, ["profile_pic"]);
    } else {
      throw SomethingWentWrong();
    }
  },
  addMember: async ({ body, image }) => {
    // if (!image) {
    //   return "Member Image is mandatory";
    // }
    const found = await DBController.Member.Member.checkMemberExists(body);
    if (found) {
      throw AlreadyExists("Member Already Exists");
    } else {
      if (body?.dob) {
        const validDate = await validDateFormat(body.dob);
        if (!validDate) {
          throw CustomError("Vaild dob format is DD/MM/YYYY");
        }
        body.dob = validDate;
      }
      const created = await DBController.Admin.Create.createMember(body, image);
      if (created != null && created != undefined) {
        return "Member Created";
      } else {
        throw SomethingWentWrong();
      }
    }
  },
  updateMember: async ({ body, image }) => {
    if (body?.dob) {
      const validDate = await validDateFormat(body.dob);
      if (!validDate) {
        throw CustomError("Vaild dob format is DD/MM/YYYY");
      }
      body.dob = validDate;
    }
    const updated = await DBController.Admin.Create.updateMember(body, image);
    if (updated != null && updated != undefined) {
      return "User Updated";
    } else {
      throw SomethingWentWrong();
    }
  },
  // deleteMember: async ({ body }) => {
  //   const removed = await DBController.Admin.Create.removeMember(body);
  //   if (removed != null && removed != undefined) {
  //     return `User ${capitalize(body.status)}`;
  //   } else {
  //     throw SomethingWentWrong();
  //   }
  // },
  addFamily: async ({ body }) => {

    if (body.relationship == "Spouse") {
      const spouseFound = await DBController.Admin.Create.checkSpouseExists(body);
      if (spouseFound != null && spouseFound != undefined) {
        return "Spouse already added"
      }
      else {
        if (body?.dob) {
          const validDate = await validDateFormat(body.dob);
          if (!validDate) {
            throw CustomError("Vaild dob format is DD/MM/YYYY");
          }
          body.dob = validDate;
        }
        const created = await DBController.Admin.Create.createFamily(body);
        if (created != null && created != undefined) {
          return "Family Created";
        } else {
          throw SomethingWentWrong();
        }
      }
    }
    else {
      const found = await DBController.Admin.Create.checkFamilyExists(body);
      if (found != null && found != undefined) {
        throw AlreadyExists("Family Already Exists");
      } else {
        if (body?.dob) {
          const validDate = await validDateFormat(body.dob);

          if (!validDate) {
            throw CustomError("Vaild dob format is DD/MM/YYYY");
          }
          body.dob = validDate;
        }

        const created = await DBController.Admin.Create.createFamily(body);
        if (created != null && created != undefined) {
          return "Family Created";
        } else {
          throw SomethingWentWrong();
        }
      }
    }
  },

  changesStatus: async ({ body }) => {
    const fetched = await DBController.Admin.Create.changesStatus(body);
    if (fetched != null && fetched != undefined) {
      return "Member Active successfully";
    } else {
      throw SomethingWentWrong();
    }
  },
  changeAppAccess: async ({ body }) => {
    if (!body?.id) throw CustomError("Member id is required");
    if (!["view", "full"].includes(body.app_access)) {
      throw CustomError("app_access must be view or full");
    }
    const fetched = await DBController.Admin.Create.changeAppAccess(body);
    if (fetched != null && fetched != undefined) {
      return body.app_access === "full"
        ? "Member access granted"
        : "Member access revoked";
    } else {
      throw SomethingWentWrong();
    }
  },
  addEvent: async ({ body, image }) => {
    if (!image) {
      return "Event Image is mandatory";
    }
    if (body?.event_date) {
      const validDate = await validDateFormat(body.event_date);
      if (!validDate) {
        throw CustomError("Vaild event date format is DD/MM/YYYY");
      }
      body.event_date = validDate;
    }
    if (body?.event_time) {
      body.event_time = await convert24HrTo12Hr(body.event_time);
    }
    const created = await DBController.Admin.Create.createEvent(body, image);
    if (created) {
      await FirebaseService.notifyOnEventCreate(created);
      return "Event Created";
    } else {
      throw SomethingWentWrong();
    }
  },
  updateEvent: async ({ body, image }) => {
    console.log("data : ", body, image);
    body.image = body;
    if (!body.image) {
      const fetchEvent = await DBController.Admin.Create.fetchEvent(body);
      body.image = fetchEvent.event_image;
    }
    if (body?.event_date) {
      const validDate = await validDateFormat(body.event_date);
      if (!validDate) {
        throw CustomError("Vaild event date format is DD/MM/YYYY");
      }
      body.event_date = validDate || fetchEvent.event_date;
    }
    if (body?.event_time) {
      body.event_time = body.event_time || fetchEvent.event_time;
      body.event_time = await convert24HrTo12Hr(body.event_time);
    }
    const created = await DBController.Admin.Create.updateEvent(body, image);
    if (created) {
      await FirebaseService.notifyOnEventCreate(created);
      return "Event Updated";
    } else {
      throw SomethingWentWrong();
    }
  },
  removeEvent: async ({ body }) => {
    console.log("data : ", body);
    const removed = await DBController.Admin.Create.deleteEvent(body);
    console.log(removed);
    if (removed[0] != 0) {
      return "Event Deleted";
    }
  },
  addImage: async ({ body, image }) => {
    const created = await DBController.Admin.Create.createImage(body, image);
    if (created != null && created != undefined) {
      return "Event Images Created";
    } else {
      throw SomethingWentWrong();
    }
  },
  addImage: async ({ body, image }) => {
    const created = await DBController.Admin.Create.createImage(body, image);
    if (created != null && created != undefined) {
      return "Event Images Created";
    } else {
      throw SomethingWentWrong();
    }
  },
  deleteImage: async ({ body }) => {
    const deleted = await DBController.Admin.Create.destroyImage(body);
    if (deleted != null && deleted != undefined) {
      return "Event Image deleted";
    } else {
      throw SomethingWentWrong();
    }
  },
  addSponser: async ({ body, image }) => {
    if (!image) {
      return "Sponser Image is mandatory";
    }

    if (body.role == "main_sponser") {
      const existing = await DBController.Admin.Create.checkSponserExists();
      if (
        existing != null &&
        existing != undefined &&
        Object.keys(existing).length != 0
      ) {
        const body = { userId: existing?.id };
        const updated = await DBController.Admin.Create.updateSponsor(
          body,
          image
        );
        // console.log("updated", updated);
        if (updated[0] == 1 && updated != null) {
          return "Sponsor Created";
        } else {
          return "Unable to Create Sponsor";
        }
      } else {
        const created = await DBController.Admin.Create.createSponser(
          body,
          image
        );
        if (created != null && created != undefined) {
          return "Sponsor Created";
        } else {
          throw SomethingWentWrong();
        }
      }
    } else {
      const created = await DBController.Admin.Create.createSponser(
        body,
        image
      );
      if (created != null && created != undefined) {
        return "Sponsor Created";
      } else {
        throw SomethingWentWrong();
      }
    }
  },
  updateSponser: async ({ body, image }) => {
    console.log("data : ", body, image);
    body.image = image;
    if (body.image == null) {
      const fetched = await DBController.Admin.Create.fetchSponser(body);
      body.image = fetched.sponser_image;
    }
    const updated = await DBController.Admin.Create.updateSponser(body);
    if (updated[0] != 0) {
      return "Sponsor Updated";
    } else {
      throw SomethingWentWrong();
    }
  },
  removeSponser: async ({ body }) => {
    console.log("datas : ", body);
    const deleted = await DBController.Admin.Create.deleteSponser(body);
    if (deleted != null && deleted != undefined) {
      return "Sponsor deleted";
    } else {
      throw SomethingWentWrong();
    }
  },
  addRoles: async ({ body }) => {
    const found = await DBController.Admin.Create.checkRoleExists(body);
    if (found != null && found != undefined) {
      throw AlreadyExists("Role Already Exists");
    } else {
      const created = await DBController.Admin.Create.createRole(body);
      if (created != null && created != undefined) {
        return "Role Created";
      } else {
        throw SomethingWentWrong();
      }
    }
  },
  destroyrole: async ({ body }) => {
    const found = await DBController.Admin.Create.checkMemberinRole(body);
    // console.log(found);
    if (found != null && found != undefined && found.length != 0) {
      throw MemberExists("Member Exist in That Role");
    } else {
      const deleted = await DBController.Admin.Create.removeRole(body);
      if (deleted != null && deleted != undefined) {
        return "Role Removed";
      } else {
        throw SomethingWentWrong();
      }
    }
  },
  fetchRoles: async ({ body }) => {
    const fetched = await DBController.Admin.Create.getRole(body);
    if (fetched != null && fetched != undefined) {
      return fetched;
    } else {
      throw SomethingWentWrong();
    }
  },
  addDesignation: async ({ body }) => {
    const created = await DBController.Admin.Create.createDesignation(body);
    if (created != null && created != undefined) {
      return "Designation Created";
    } else {
      throw SomethingWentWrong();
    }
  },
  removeDesignation: async ({ body }) => {
    const removed = await DBController.Admin.Create.destroyDesignation(body);
    if (removed != null && removed != undefined) {
      return "Designation Deleted";
    } else {
      throw SomethingWentWrong();
    }
  },
  uploadGreenChannelPdf: async ({ image, body, file }) => {
    var pdf_name = "";
    if (body?.pdf_name?.trim()) {
      pdf_name = String(body.pdf_name?.trim());
    } else {
      pdf_name = file.originalname;
    }
    if (image) {
      image.pdf_name = pdf_name;
      const created = await DBController.GreenChannel.Upload.uploadPdf(image);
      if (Boolean(created)) {
        return "Pdf Uploaded";
      } else {
        return "Failed to upload the pdf";
      }
    } else {
      return "Failed to upload the pdf";
    }
  },
  fetchBanners: async ({ body }) => {
    const fetched = await DBController.Admin.Banners.getBanners(body);
    if (fetched != null && fetched != undefined && fetched.length != 0) {
      return fetched.map((row) => mapMediaFields(row, ["banner_image"]));
    }
    return [];
  },
  createBanners: async ({ body, image }) => {
    const created = await DBController.Admin.Banners.createBanner(body, image);
    if (created != null && created != undefined) {
      return "Banner Image Created";
    } else {
      throw SomethingWentWrong("Failed to upload the banner");
    }
  },
  deleteBanners: async ({ body }) => {
    return await DBController.Admin.Banners.deleteBanners(body);
  },
  verifyBloodRequest: async ({ body }) => {
    const fetched = await DBController.Member.BloodReq.verifyBloodRequest(body);
    if (fetched != null && fetched != undefined) {
      return "Blood Request Verified";;
    } else {
      return "Failed to verify the blood request";
    }
  },
  fetchedRequests: async ({ body, image }) => {
    const fetched = await DBController.Member.BloodReq.fetchedRequests(body);
    if (fetched != null && fetched != undefined) {
      for (let index = 0; index < fetched.length; index++) {
        fetched[index].createdAt = moment(fetched[index].createdAt).format("DD-MM-YYYY");
      }
      return fetched;
    } else {
      return [];
    }
  },

  createBusinessCategory: async ({ body }) => {
    const fetched = await DBController.Member.businessType.fetched_category(body);
    if (fetched != null && fetched !== undefined) {
      return "Business Category Already Exists";
    }
    const created = await DBController.Member.businessType.add_category(body);
    if (created != null && created != undefined) {
      return "Business Category Added Successfully";
    } else {
      return "Failed to add the business category";
    }

  },
  createBusinessSubCategory: async ({ body }) => {
    const fetched = await DBController.Member.businessType.checkCategoryExists(body);
    console.log("🚀 ~ createBusinessSubCategory: ~ fetched:", fetched)
    if (fetched != null && fetched != undefined) {
      const id = fetched.id
      const created = await DBController.Member.businessType.add_subCategory(body, id);
      if (created != null && created != undefined) {
        return "Business Sub Category Added Successfully";
      }
    } else {
      return "Failed to add the business category";
    }
  },
  fetchedBusinessName: async ({ body, image }) => {
    const fetched = await DBController.Member.businessType.list_businessName(body);
    if (fetched != null && fetched != undefined) {
      return fetched;
    } else {
      return [];
    }
  },
  createNotification: async ({ body }) => {
    const created = await DBController.Member.notification.create_notification(body);
    if (created != null && created != undefined) {
      await FirebaseService.notification(created);
      return "Notification created Successfully";
    } else {
      return "Failed to create notification";
    }


  },
  getNotification: async ({ body }) => {
    const fetched = await DBController.Member.notification.get_all_Notification(body);
    if (fetched != null && fetched != undefined) {
      return fetched;
    } else {
      return [];
    }
  },
  getOneNotification: async ({ body }) => {
    const fetched = await DBController.Member.notification.get_One_Notification(body);
    if (fetched != null && fetched != undefined) {
      return fetched;
    } else {
      return [];
    }
  },
  createFolder: async ({ body, image }) => {
    body.image = image
    const created = await DBController.Member.imageFolder.create_folder(body);
    if (created != null && created != undefined) {

      return "Image Folder Created Successfully";
    } else {
      return "Failed To Create Image Folder";
    }
  },
  getallFolder: async ({ body }) => {
    const fetched = await DBController.Member.imageFolder.getallFolder(body);
    if (fetched != null && fetched != undefined) {
      return fetched;
    } else {
      return [];
    }
  },
};
