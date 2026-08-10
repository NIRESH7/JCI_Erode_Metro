import express from "express";
import { connection } from "./connection.js";
import * as Models from "./models/index.js";
import bcrypt from "bcrypt";
import require from "requirejs";
import multer from "multer";
import { raw } from "mysql";
import { normalizePhone, phonesMatch } from "../utils/phoneUtils.js";
const { Op, Sequelize, json, where } = require("sequelize");
export class DBController { }
DBController.Models = Models;
DBController.connection = connection;

DBController.defaults = {};

//create functions admin
DBController.GreenChannel = {
  Upload: {
    uploadPdf: async (pdf) => {
      try {
        return await DBController.Models.GreenChannel.create(pdf);
      } catch (error) {
        return null;
      }
    },
  },
};

DBController.Admin = {
  Create: {
    createMember: async (data, image) => {

      try {
        console.log(data);
        return await DBController.Models.Member.create(
          {
            profile_pic: image || "/images/placeholder.jpg",
            membership_id: data.membership_id || data.member_id,
            user_name: data.user_name,
            email: data.email,
            contact: "+91" + data.contact,
            gender: data.gender,
            dob: data.dob,
            location: data.location,
            blood_group: data.blood_group,
            willing_to_donate: data.willing_to_donate,
            office_name: data.office_name,
            job: data.job,
            sector: data.sector,
            martial_status: data.martial_status,
            role: data.role,
            jci_location: data.jci_location,
            type: data.type,
            status: "active",
            app_access: "view",
          },

          { raw: true }
        );
      } catch (error) {
        console.log(error);
        return null;
      }
    },
    updateMember: async (data, image) => {
      try {
        const existingMember = await DBController.Models.Member.findOne({
          where: {
            id: data.id,
          },
        });

        if (!existingMember) {
          return null;
        }
        const roleValue =
          data.role != null && String(data.role).trim() !== ""
            ? String(data.role).trim()
            : existingMember.role;
        const sectorValue =
          typeof data.sector === "object" && data.sector != null
            ? data.sector.sector || data.sector.value || existingMember.sector
            : data.sector || existingMember.sector;
        const updatedMember = await existingMember.update({
          profile_pic: image || existingMember.profile_pic,
          membership_id: data.membership_id || existingMember.membership_id,
          user_name: data.user_name || existingMember.user_name,
          email: data.email || existingMember.email,
          contact: data.contact || existingMember.contact,
          gender: data.gender || existingMember.gender,
          dob: data.dob || existingMember.dob,
          location: data.location || existingMember.location,
          blood_group: data.blood_group || existingMember.blood_group,
          willing_to_donate:
            data.willing_to_donate || existingMember.willing_to_donate,
          office_name: data.office_name || existingMember.office_name,
          job: data.job || existingMember.job,
          sector: sectorValue,
          martial_status: data.martial_status || existingMember.martial_status,
          role: roleValue,
          jci_location: data.jci_location || existingMember.jci_location,
          type: data.type || existingMember.type,
        });
        return updatedMember;
      } catch (error) {
        return null;
      }
    },

    changesStatus: async (data) => {
      try {
        return await DBController.Models.Member.update(
          {
            status: data.status,
          },
          {
            where: {
              id: data.id,
            },
          }
        );
      } catch (error) {
        console.log(error);
        return null;
      }
    },
    changeAppAccess: async (data) => {
      try {
        return await DBController.Models.Member.update(
          {
            app_access: data.app_access,
          },
          {
            where: {
              id: data.id,
            },
          }
        );
      } catch (error) {
        console.log(error);
        return null;
      }
    },
    list_businessType: async (data) => {
      try {
        return await DBController.Models.BusinessType.findAll({
          raw: true,
        }

        )
      } catch (error) {
        return null;
      }
    },
    updateSponsor: async (data, image) => {
      try {
        return await DBController.Models.Sponser.update(
          {
            sponser_name: data.sponser_name,
            sponser_image: image,
            sponser_contact: data.sponser_contact,
            sponser_email: data.sponser_email,
            sponser_description: data.sponser_description,
            sponser_location: data.sponser_location,
            sponser_website: data.sponser_website,
            role: data.role,
            status: "active",
          },
          {
            where: {
              id: data.userId,
            },
          }
        );
      } catch (error) {
        return null;
      }
    },
    fetchMember: async (data) => {
      try {
        return await DBController.Models.Member.findOne({
          where: {
            id: data.id,
          },
          attributes: { exclude: ["status", "createdAt", "updatedAt"] },
          raw: true,
        });
      } catch (error) {
        return null;
      }
    },
    checkSpouseExists: async (data) => {
      try {
        return await DBController.Models.Family.findOne({
          where: {
            member_id: data.member_id,
            relationship: data.relationship,
          },
        });
      } catch (error) {
        return null;
      }
    },
    checkFamilyExists: async (data) => {
      try {
        return await DBController.Models.Family.findOne({
          where: {
            member_id: data.member_id,
            name: data.name,
            dob: data.dob,
            relationship: data.relationship,
          },
        });
      } catch (error) {
        return null;
      }
    },
    getSpousesByMemberIdheckFamilyExists: async (data) => {
      try {
        return await DBController.Models.Family.findOne({
          where: {
            member_id: data.member_id,
            name: data.name,
            dob: data.dob,
            relationship: data.relationship,
          },
        });
      } catch (error) {
        return null;
      }
    },
    createFamily: async (data) => {

      try {
        return await DBController.Models.Family.create(
          {
            member_id: data?.member_id,
            name: data?.name,
            dob: data.dob,
            anniversary: data?.anniversary,
            blood_group: data?.blood_group,
            relationship: data.relationship,
          },
          { raw: true }
        );
      } catch (error) {
        console.log(error);
        return null;
      }
    },

    deleteFamily: async (data) => {
      try {
        return await DBController.Models.Family.destroy({
          where: {
            id: data.id,
          },
        });
      } catch (error) {
        return null;
      }
    },
    fetchEvent: async (data) => {
      try {
        return await DBController.Models.Events.findOne({
          where: {
            id: data.id,
          },
          raw: true,
        });
      } catch (error) {
        return null;
      }
    },
    createEvent: async (data, image) => {
      try {
        return await DBController.Models.Events.create(
          {
            event_name: data.event_name,
            event_image: image || NULL,
            event_date: data.event_date,
            event_time: data.event_time,
            event_location: data.event_location,
            event_desc: data.event_desc,
            status: "active",
          },
          { raw: true }
        );
      } catch (error) {
        return null;
      }
    },
    updateEvent: async (data, image) => {
      try {
        return await DBController.Models.Events.update(
          {
            event_name: data.event_name,
            event_image: image || NULL,
            event_date: data.event_date,
            event_time: data.event_time,
            event_location: data.event_location,
            event_desc: data.event_desc,
            status: "active",
          },
          { where: { id: data.id } },
          { raw: true }
        );
      } catch (error) {
        return null;
      }
    },
    deleteEvent: async (data) => {
      try {
        return await DBController.Models.Events.destroy({
          where: {
            id: data.id,
          },
        });
      } catch (error) {
        return null;
      }
    },
    createImage: async (data, image) => {
      try {
        return await DBController.Models.eventsImage.create({
          event_id: data.event_id,
          event_name: data.event_name,
          event_image: image,
          status: "active",
        });
      } catch (error) {
        return null;
      }
    },
    destroyImage: async (data) => {
      try {
        return await DBController.Models.eventsImage.update(
          {
            status: data.status,
          },
          {
            where: {
              id: data.id,
            },
          }
        );
      } catch (error) {
        return null;
      }
    },
    fetchSponser: async (data) => {
      try {
        return await DBController.Models.Sponser.findOne({
          where: {
            id: data.id,
          },
          raw: true,
        });
      } catch (error) {
        return null;
      }
    },
    createSponser: async (data, image) => {
      try {
        return await DBController.Models.Sponser.create({
          sponser_name: data.sponser_name,
          sponser_image: image,
          sponser_contact: data.sponser_contact,
          sponser_email: data.sponser_email,
          sponser_description: data.sponser_description,
          sponser_location: data.sponser_location,
          sponser_website: data.sponser_website,
          sponser_expiryTime: data.sponser_expiryTime,
          role: data.role,
          status: "active ",
        });
      } catch (error) {
        return null;
      }
    },
    updateSponser: async (data) => {
      try {
        return await DBController.Models.Sponser.update(
          {
            sponser_name: data.sponser_name,
            sponser_image: data.image,
            sponser_contact: data.sponser_contact,
            sponser_email: data.sponser_email,
            sponser_description: data.sponser_description,
            sponser_location: data.sponser_location,
            sponser_website: data.sponser_website,
            sponser_expiryTime: data.sponser_expiryTime,
            role: data.role,
            status: "active ",
          },
          {
            where: {
              id: data.id,
            },
          }
        );
      } catch (error) {
        return null;
      }
    },
    deleteSponser: async (data) => {
      try {
        return await DBController.Models.Sponser.update(
          {
            status: "inactive",
          },
          {
            where: {
              id: data.id,
            },
          }
        );
      } catch (error) {
        return null;
      }
    },
    createDesignation: async (data) => {
      try {
        return await DBController.Models.Designation.create({
          member_id: data.member_id,
          designation_name: data.designation_name,
          designation_year: data.designation_year,
        });
      } catch (error) {
        return null;
      }
    },
    destroyDesignation: async (data) => {
      try {
        return await DBController.Models.Designation.destroy({
          where: {
            id: data.id,
          },
        });
      } catch (error) {
        return null;
      }
    },
    createRole: async (data) => {
      try {
        return await DBController.Models.userRoles.create({
          role_name: data.role,
        });
      } catch (error) {
        return null;
      }
    },
    removeRole: async (data) => {

      try {
        return await DBController.Models.userRoles.destroy({
          where: {
            role_name: data.role,
          },
        });
      } catch (error) {

        return null;
      }
    },
    getRole: async (data) => {
      try {
        return await DBController.Models.userRoles.findAll({});
      } catch (error) {
        return null;
      }
    },
    checkRoleExists: async (data) => {
      try {
        return await DBController.Models.userRoles.findOne({
          where: {
            role_name: data.role,
          },
        });
      } catch (error) {
        return null;
      }
    },
    checkSponserExists: async () => {
      try {
        return await DBController.Models.Sponser.findOne({
          where: {
            role: "main_sponser",
          },
        });
      } catch (error) {
        return null;
      }
    },
    checkMemberinRole: async (data) => {
      try {
        return await DBController.Models.Member.findAll({
          where: {
            role: data.role,
          },
        });
      } catch (error) {
        return null;
      }
    },
  },
  Auth: {
    signup: async (data) => {
      try {
        const hashedPassword = await bcrypt.hash(data.password, 10);
        return await DBController.Models.Admin.create({
          email_id: data.email_id,
          phone: data.phone,
          username: data.username,
          password: hashedPassword,
          status: "active",
          user_type: "USER",
        });
      } catch (error) {
        return null;
      }
    },
    signin: async (data) => {
      try {

        return await DBController.Models.Admin.findOne({
          where: {
            [Op.or]: [
              { email_id: data?.login },
              { phone: "+91" + data?.phone || data?.login },
              { username: data?.username || data?.login },
            ],
          },
          raw: true,
        });
      } catch (error) {
        return null;
      }
    },
    checkAdminExists: async (data) => {

      try {
        return await DBController.Models.Admin.findOne({
          where: {
            [Op.or]: [
              {
                email_id: data.email_id,
              },
              {
                phone: data.phone,
              },
            ],
          },
        });
      } catch (error) {
        return null;
      }
    },
  },
  Banners: {
    getBanners: async (data) => {
      try {
        return await DBController.Models.Banners.findAll();
      } catch (error) {
        return null;
      }
    },
    createBanner: async (data, image) => {
      try {
        return await DBController.Models.Banners.create({
          banner_image: image,
        });
      } catch (error) {
        return null;
      }
    },
    deleteBanners: async (data) => {
      try {
        const destroy = await DBController.Models.Banners.destroy({
          where: {
            id: data.id,
          },
        });
        if (destroy === 1) {
          return deleted;
        } else {
          throw Failed;
        }
      } catch (error) {
        return null;
      }
    },
  },
};
// create functions admin End

//Member
DBController.Member = {
  Member: {
    fetch_members: async (data) => {
      try {
        const where = {
          status: "active",
        };
        if (data?.app_access === "full") {
          where.app_access = "full";
        }
        return await DBController.Models.Member.findAll({
          where,
          order: [["user_name", "ASC"]],
        });
      } catch (error) {
        return null;
      }
    },
    fetch_inactive_member: async (data) => {
      try {
        return await DBController.Models.Member.findAll({
          where: {
            status: "inactive",
          },
          order: [["user_name", "ASC"]],
        });
      } catch (error) {
        return null;
      }
    },
    fetchone_member: async (data) => {
      try {
        return await DBController.Models.Member.findOne({
          where: {
            id: data.id,
            status: "active",
          }, raw: true,
        });
      } catch (error) {
        return null;
      }
    },
    fetchone_inactivemember: async (data) => {
      try {
        return await DBController.Models.Member.findOne({
          where: {
            id: data.id,
            status: "inactive",
          }, raw: true,
        });
      } catch (error) {
        console.log(error);
        return null;
      }
    },
    checkMemberExists: async (data) => {
      try {
        return await DBController.Models.Member.findOne({
          where: {
            email: data.email,
            contact: data.contact,
            status: "active",
          },
        });
      } catch (error) {
        return null;
      }
    },
    fetchdob: async (data) => {
      try {
        return await DBController.Models.Member.findAll({
          where: {
            status: "active",
          },
          attributes: ["user_name", "dob", 'profile_pic', 'contact'],
        });
      } catch (error) {
        return null;
      }
    },
    fetch_family: async (data) => {
      try {
        return await DBController.Models.Family.findAll({
          where: {
            member_id: data.id,
          },
        });
      } catch (error) {
        return null;
      }
    },
    fetch_designation: async (data) => {
      if (data.id == "") {
        try {
          return await DBController.Models.Designation.findAll({
            include: Models.Member,
          });
        } catch (error) {
          return null;
        }
      } else {
        try {
          return await DBController.Models.Designation.findAll({
            where: {
              //id: data.id,
              member_id: data.id,
            },
            include: Models.Member,
          });
        } catch (error) {
          return null;
        }
      }
    },
    fetch_roh: async (data) => {
      try {
        return await DBController.Models.Designation.findAll({
          where: {
            designation_year: data.year,
          },
          include: Models.Member,
        });
      } catch (error) {
        return null;
      }
    },

    fetch_bom: async (data) => {
      const checkId = data.id;
      const accessFilter =
        data?.app_access === "full" ? { app_access: "full" } : {};

      if (data.id != null && data.id != undefined && Object.keys(data).length != 0 && Boolean(checkId) != false) {
        try {
          return await DBController.Models.Member.findAll({
            where: {
              id: data.id,
              type: "boardmember",
              status: "active",
              ...accessFilter,
            }, raw: true,
          });
        } catch (error) {
          return null;
        }
      } else {
        try {
          return await DBController.Models.Member.findAll({
            where: {
              type: "boardmember",
              status: "active",
              role: {
                [Op.ne]: 'Member'
              },
              ...accessFilter,
            }, raw: true,
          });
        } catch (error) {
          return null;
        }
      }
    },
    fetch_blood: async (data) => {
      if (data.id == "") {
        try {
          return await DBController.Models.Member.findAll({
            where: {
              willing_to_donate: "yes",
              status: "active",
            },
          });
        } catch (error) {
          console.log(error);
          return null;
        }
      } else {
        try {
          return await DBController.Models.Member.findAll({
            where: {
              id: data.id,
              willing_to_donate: "yes",
              status: "active",
            },
          });
        } catch (error) {
          return null;
        }
      }
    },
    fetchMemberByDob: async (date) => {
      try {
        return await DBController.Models.Member.findAll(
          {
            where: {
              dob: {
                [Op.like]: `%${date}%`,
              },
              status: "active",
            },
            raw: true,
          },
          {
            attributes: [
              "user_name",
              "gender",
              // Sequelize.fn("DATE_FORMAT", Sequelize.col("dob"), "%d/%m"),
            ],
          }
        );
      } catch (error) {
        // console.log("error :>> ", error);
        return null;
      }
    },
    fetchGreenChannelPds: async () => {
      try {
        return await DBController.Models.GreenChannel.findAll(
          {
            raw: true,
            order: [["createdAt", "DESC"]],
            // attributes: ["pdf_url"],
          }
          // {
          //   raw: true,
          // },
          // {
          //   attributes: ["pdf_url"],
          // }
        );
      } catch (error) {
        return null;
      }
    },
  },
  Event: {
    fetchall_event: async () => {
      try {
        return await DBController.Models.Events.findAll({
          raw: true,
          order: [["createdAt", "DESC"]],
        });
      } catch (error) {
        return [];
      }
    },
    fetchone_event: async (data) => {
      try {
        return await DBController.Models.Events.findOne({
          where: {
            id: Number(data.id),
          },
          raw: true,
        });
      } catch (error) {
        return null;
      }
    },

    fetchEventsByDate: async (inpDate) => {
      try {
        return await DBController.Models.Events.findAll({
          where: {
            event_date: inpDate,
          },
          raw: true,
        });
      } catch (error) {
        return [];
      }
    },

    fetch_image: async (data) => {
      try {
        return await DBController.Models.eventsImage.findAll({
          where: {
            event_id: data.id,
          },
        });
      } catch (error) {
        return null;
      }
    },
    fetch_images: async (data) => {
      try {
        return await DBController.Models.eventsImage.findAll();
      } catch (error) {
        return null;
      }
    },
  },
  Sponser: {
    fetch_main_sponser: async (data) => {
      if (data.id == "") {
        try {
          return await DBController.Models.Sponser.findAll({
            where: {
              role: "main_sponser",
              status: "active",
            },
          });
        } catch (error) {
          return null;
        }
      } else {
        try {
          return await DBController.Models.Sponser.findOne({
            where: {
              id: data.id,
              role: "main_sponser",
              status: "active",
            },
          });
        } catch (error) {
          return null;
        }
      }
    },
    fetch_sponser: async (data) => {
      if (data.id == "") {
        try {
          return await DBController.Models.Sponser.findAll({
            where: {
              role: "sponser",
              status: "active",
            }, raw: true
          });
        } catch (error) {
          console.log(error);
          return null;
        }
      } else {
        try {
          return await DBController.Models.Sponser.findAll({
            where: {
              id: data.id,
              role: "sponser",
              status: "active",
            }, raw: true
          });
        } catch (error) {
          console.log(error);
          return null;
        }
      }
    },
  },
  Banners: {
    fetch_Banners: async (data) => {
      try {
        return await DBController.Models.Banners.findAll();
      } catch (error) {
        return null;
      }
    },
  },
  BloodReq: {
    createBloodReq: async (data) => {
      try {
        return await DBController.Models.BloodReq.create({
          NameOfPatient: data.NameOfPatient,
          BloodGroup: data.BloodGroup,
          NoOfUnits: data.NoOfUnits,
          Hospital_name: data.Hospital_name,
          location: data.location,
          Contact: data.Contact,
          Attender: data.Attender,
          created_by: data.created_by || data.VerifiedBy || '',
        });
      } catch (error) {
        console.log(error);
        return null;
      }
    },

    verifyBloodRequest: async (data) => {
      try {
        return await DBController.Models.BloodReq.update(
          { created_by: data.verifiedBy || data.VerifiedBy || data.created_by || '' },
          { where: { id: data.id } }
        );
      } catch (error) {
        console.log("error", error);
        return null;
      }
    },
    fetched_requests: async (data) => {
      try {
        return await DBController.Models.BloodReq.findAll({
          attributes: [
            "id",
            "NameOfPatient",
            "BloodGroup",
            "NoOfUnits",
            "Hospital_name",
            "location",
            "Contact",
            "Attender",
            "created_by",
            "createdAt",
          ],
          order: [["createdAt", "DESC"]],
          raw: true,
        });
      } catch (error) {
        console.log("error", error);
        return null;
      }
    },
    fetchedRequests: async (data) => {
      try {
        return await DBController.Models.BloodReq.findAll({
          attributes: [
            "id",
            "NameOfPatient",
            "BloodGroup",
            "NoOfUnits",
            "Hospital_name",
            "location",
            "Contact",
            "Attender",
            "created_by",
            "createdAt",
          ],
          order: [["createdAt", "DESC"]],
          raw: true,
        });
      } catch (error) {
        return null;
      }
    },

    fetch_one_request: async (id) => {
      try {
        return await DBController.Models.BloodReq.findOne({
          where: {
            id: id,
          },
          raw: true,
        });
      } catch (error) {
        return null;
      }
    },
  },
  Folders: {
    fetch_folders: async (data) => {
      try {
        return await DBController.Models.folderName.findAll({
          attributes: ["id", "folderName", "title", "description", "image"],
          raw: true,
        });
      } catch (error) {
        return null;
      }
    },
  },
  businessType: {
    add_category: async (data) => {
      try {
        return await DBController.Models.BusinessType.create({
          Business_name: data.Business_name,
          parent_Id: 0,
        });
      } catch (error) {
        console.log(error);
        return null;
      }
    },
    add_subCategory: async (data, id) => {
      try {
        return await DBController.Models.BusinessType.create({
          Business_name: data.Business_name,
          parent_Id: id,
        });
      } catch (error) {
        console.log(error);
        return null;
      }
    },
    list_businessName: async (data) => {
      try {
        return await DBController.Models.BusinessType.findAll({

        });
      } catch (error) {
        return null;
      }
    },

    fetched_category: async (data) => {
      try {
        return await DBController.Models.BusinessType.findOne({
          where: {
            Business_name: data.Business_name
          }
        });
      } catch (error) {
        return null;
      }
    },
    checkCategoryExists: async (data) => {
      try {
        return await DBController.Models.BusinessType.findOne({
          where: {
            id: data.id
          }
        });
      } catch (error) {
        console.log(error);
        return null;
      }
    },
  },
  notification: {
    create_notification: async (data) => {
      try {
        return await DBController.Models.notification.create({
          title: data.title,
          description: data.description,
          notification_type: data.notification_type
        });
      } catch (error) {
        console.log(error);
        return null;
      }
    },
    get_all_Notification: async (data) => {
      try {
        return await DBController.Models.notification.findAll({
          where: {
            notification_type: "member"
          }
        });
      } catch (error) {
        return null;
      }
    },
    get_One_Notification: async (data) => {
      try {
        if (notification_type === "notification_type") {
          return await DBController.Models.notification.findOne({
            where: {
              notification_type: "member"
            }
          });
        } else {
          return await DBController.Models.notification.findOne({
            where: {
              notification_type: "boardMember"
            }
          });
        }
      } catch (error) {
        return null;
      }
    }
  },
  imageFolder: {
    create_folder: async (data) => {
      try {
        return await DBController.Models.folderName.create({
          folderName: data.folderName,
          title: data.title,
          description: data.description,
          image: data.image,
          status: data.status,
        });
      } catch (error) {
        console.log(error);
        return null;
      }
    },
    getallFolder: async (data) => {
      try {
        return await DBController.Models.folderName.findAll({
          // where: {
          //   status: "active"
          // }
        });
      } catch (error) {
        return null;
      }
    },
  },

};

DBController.MemberAuth = {
  findByMemberId: async (memberId) => {
    return await DBController.Models.MemberAuth.findOne({ where: { member_id: memberId } });
  },
  findByEmailOrPhone: async (login) => {
    const email = login?.includes("@") ? login.trim().toLowerCase() : null;
    const phone = !email ? normalizePhone(login) : null;

    if (email) {
      const byLoginEmail = await DBController.Models.MemberAuth.findOne({
        where: { login_email: email },
      });
      if (byLoginEmail) return byLoginEmail;

      const member = await DBController.MemberAuth.findMemberByEmail(email);
      if (member) {
        return await DBController.MemberAuth.findByMemberId(member.id);
      }
      return null;
    }

    return await DBController.Models.MemberAuth.findOne({
      where: { login_phone: phone },
    });
  },
  findByGoogleId: async (googleId) => {
    return await DBController.Models.MemberAuth.findOne({ where: { google_id: googleId } });
  },
  createAuth: async (data) => {
    return await DBController.Models.MemberAuth.create(data);
  },
  updateAuth: async (memberId, data) => {
    const auth = await DBController.Models.MemberAuth.findOne({ where: { member_id: memberId } });
    if (!auth) return null;
    return await auth.update(data);
  },
  findMemberByPhone: async (phone) => {
    const members = await DBController.Models.Member.findAll({
      where: { status: "active" },
    });
    return members.find((m) => phonesMatch(m.contact, phone)) || null;
  },
  findMemberByEmail: async (email) => {
    return await DBController.Models.Member.findOne({
      where: { email: email?.trim().toLowerCase(), status: "active" },
    });
  },
  findMembersByName: async (userName) => {
    const normalized = userName?.trim().toLowerCase();
    if (!normalized) return [];
    const members = await DBController.Models.Member.findAll({
      where: { status: "active" },
    });
    return members.filter(
      (m) => m.user_name?.trim().toLowerCase() === normalized
    );
  },
  createResetToken: async (data) => {
    return await DBController.Models.PasswordResetToken.create(data);
  },
  findValidResetToken: async (memberId, tokenHash) => {
    return await DBController.Models.PasswordResetToken.findOne({
      where: {
        member_id: memberId,
        token_hash: tokenHash,
        used: false,
        expires_at: { [Op.gt]: new Date() },
      },
    });
  },
  markResetTokenUsed: async (id) => {
    return await DBController.Models.PasswordResetToken.update(
      { used: true },
      { where: { id } }
    );
  },
};

DBController.MemberSession = {
  upsertSession: async ({ member_id, fcm_token, device_info }) => {
    const now = new Date();
    if (fcm_token) {
      const existing = await DBController.Models.MemberSession.findOne({
        where: { fcm_token },
      });
      if (existing) {
        return await existing.update({ member_id, last_active: now, device_info });
      }
    }
    const byMember = await DBController.Models.MemberSession.findOne({
      where: { member_id },
      order: [["updatedAt", "DESC"]],
    });
    if (byMember) {
      return await byMember.update({
        fcm_token: fcm_token || byMember.fcm_token,
        last_active: now,
        device_info,
      });
    }
    return await DBController.Models.MemberSession.create({
      member_id,
      fcm_token,
      device_info,
      last_active: now,
    });
  },
  getFcmToken: async (memberId) => {
    const session = await DBController.Models.MemberSession.findOne({
      where: { member_id: memberId, fcm_token: { [Op.ne]: null } },
      order: [["last_active", "DESC"]],
    });
    return session?.fcm_token || null;
  },
  getActiveMembers: async () => {
    const since = new Date();
    since.setDate(since.getDate() - 30);
    const sessions = await DBController.Models.MemberSession.findAll({
      where: { last_active: { [Op.gte]: since } },
      order: [["last_active", "DESC"]],
    });
    const memberIds = [...new Set(sessions.map((s) => s.member_id))];
    if (!memberIds.length) return [];
    return await DBController.Models.Member.findAll({
      where: { id: memberIds, status: "active" },
    });
  },
};

DBController.Referral = {
  create: async (data) => {
    return await DBController.Models.Referral.create(data);
  },
  findById: async (id) => {
    return await DBController.Models.Referral.findOne({ where: { id } });
  },
  findGiven: async (memberId) => {
    return await DBController.Models.Referral.findAll({
      where: { referrer_member_id: memberId },
      order: [["createdAt", "DESC"]],
    });
  },
  findReceived: async (memberId) => {
    return await DBController.Models.Referral.findAll({
      where: { linked_member_id: memberId },
      order: [["createdAt", "DESC"]],
    });
  },
  findPendingByPhone: async (phone) => {
    const referrals = await DBController.Models.Referral.findAll({
      where: { status: "pending", referred_member_id: null },
    });
    return referrals.filter((r) => phonesMatch(r.referred_phone, phone));
  },
  update: async (id, data) => {
    const ref = await DBController.Models.Referral.findOne({ where: { id } });
    if (!ref) return null;
    return await ref.update(data);
  },
  sumConnectAmount: async () => {
    const result = await DBController.Models.Referral.sum("connect_amount", {
      where: {
        status: "accepted",
        connection_type: "completed",
        connect_amount: { [Op.ne]: null },
      },
    });
    return result || 0;
  },
};

DBController.MemberNotification = {
  create: async (data) => {
    return await DBController.Models.MemberNotification.create(data);
  },
  findForMember: async (memberId, { limit = 50 } = {}) => {
    return await DBController.Models.MemberNotification.findAll({
      where: { member_id: memberId },
      order: [["createdAt", "DESC"]],
      limit,
    });
  },
  unreadCount: async (memberId) => {
    return await DBController.Models.MemberNotification.count({
      where: { member_id: memberId, is_read: false },
    });
  },
  markRead: async (memberId, ids) => {
    const where = { member_id: memberId, is_read: false };
    if (Array.isArray(ids) && ids.length > 0) {
      where.id = { [Op.in]: ids };
    }
    await DBController.Models.MemberNotification.update(
      { is_read: true },
      { where }
    );
    return true;
  },
  existsForReferralType: async (memberId, referralId, type) => {
    const row = await DBController.Models.MemberNotification.findOne({
      where: {
        member_id: memberId,
        referral_id: referralId,
        type,
      },
    });
    return !!row;
  },
};

DBController.FitnessStory = {
  create: async (data) => {
    return await DBController.Models.FitnessStory.create(data);
  },
  findById: async (id) => {
    return await DBController.Models.FitnessStory.findOne({ where: { id } });
  },
  findActive: async (now) => {
    return await DBController.Models.FitnessStory.findAll({
      where: { expires_at: { [Op.gt]: now } },
      order: [["createdAt", "ASC"]],
    });
  },
  findExpired: async (now) => {
    return await DBController.Models.FitnessStory.findAll({
      where: { expires_at: { [Op.lte]: now } },
    });
  },
  deleteById: async (id) => {
    return await DBController.Models.FitnessStory.destroy({ where: { id } });
  },
};