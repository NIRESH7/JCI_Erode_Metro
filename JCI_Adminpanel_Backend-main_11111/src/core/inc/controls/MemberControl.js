import moment from "moment";
import { DBController } from "../../database/DbController.js";
import { SomethingWentWrong } from "../../errors/ErrorConstant.js";
import { convertDateToIST } from "../../utils/moment.js";
import { mapMediaFields } from "../../utils/mediaUrl.js";

export class MemberControl { }

MemberControl.Member = {
  fetchMember: async ({ body, query }) => {
    const fetched = await DBController.Member.Member.fetch_members({
      ...(body || {}),
      ...(query || {}),
    });
    if (fetched != null && fetched != undefined) {
      return fetched.map((row) => mapMediaFields(row, ["profile_pic"]));
    } else {
      return [];
    }
  },
  fetchInActiveMember: async ({ body }) => {
    const fetched = await DBController.Member.Member.fetch_inactive_member(body);
    if (fetched != null && fetched != undefined) {
      return fetched.map((row) => mapMediaFields(row, ["profile_pic"]));
    } else {
      return [];
    }
  },
  fetchoneMember: async ({ body }) => {
    const fetched = await DBController.Member.Member.fetchone_member(body);
    if (fetched != null && fetched != undefined) {
      return mapMediaFields(fetched, ["profile_pic"]);
    } else {
      return [];
    }
  },

  fetchDob: async ({ body }) => {
    const fetched = await DBController.Member.Member.fetchdob(body);
    if (fetched != null && fetched != undefined) {
      return fetched.map((row) => mapMediaFields(row, ["profile_pic"]));
    } else {
      return [];
    }
  },
  fetchFamily: async ({ body }) => {
    const fetched = await DBController.Member.Member.fetch_family(body);
    if (fetched != null && fetched != undefined) {
      return fetched;
    } else {
      return [];
    }
  },
  fetchDesignation: async ({ body }) => {
    const fetched = await DBController.Member.Member.fetch_designation(body);
    if (fetched != null && fetched != undefined) {
      return fetched;
    } else {
      return [];
    }
  },
  fetchRoh: async ({ body }) => {
    const fetched = await DBController.Member.Member.fetch_roh(body);
    if (fetched != null && fetched != undefined) {
      return fetched;
    } else {
      return [];
    }
  },
  fetchBoardmembers: async ({ body, query }) => {
    const fetched = await DBController.Member.Member.fetch_bom({
      ...(body || {}),
      ...(query || {}),
    });
    if (fetched != null && fetched != undefined && Object.keys(fetched).length != 0) {


      var roleOrder = [
        'President',
        'Immediate Past President',
        'Vice President - Management',
        'Vice President - Individual Development',
        'Past President',
        'Vice President - Community',
        'Vice President - Resource, Business and Internationalisim',
        'Secretary',
        'Joint Secretary',
        'Treasurer',
        'Director'
      ];

      fetched.sort(function (a, b) {
        return roleOrder.indexOf(a.role) - roleOrder.indexOf(b.role);
      });
      return fetched;
    } else {
      return "Not Found";
    }
  },
  fetchDonars: async ({ body }) => {
    const fetched = await DBController.Member.Member.fetch_blood(body);
    if (fetched != null && fetched != undefined) {
      return fetched;
    } else {
      return [];
    }
  },
  fetchGreenChannelPdfs: async () => {
    var fetched = await DBController.Member.Member.fetchGreenChannelPds();
    if (Array.isArray(fetched) && fetched?.length > 0) {
      await Promise.all(
        fetched
          ?.map(async (itx) => {
            if (itx?.createdAt) {
              itx.createdAt = await convertDateToIST(itx?.createdAt);
            }
            delete itx?.updatedAt;
          })
          .filter((notNull) => notNull)
      );
      return fetched;
    } else {
      return [];
    }
  },
};
MemberControl.Event = {
  fetchallEvent: async ({ body }) => {
    return await DBController.Member.Event.fetchall_event(body);
  },
  fetchoneEvent: async ({ body }) => {
    return await DBController.Member.Event.fetchone_event(body);
  },
  fetchImage: async ({ body }) => {
    const fetched = await DBController.Member.Event.fetch_image(body);
    if (fetched != null && fetched != undefined) {
      return fetched;
    } else {
      return [];
    }
  },
  fetchImages: async ({ body }) => {
    const fetched = await DBController.Member.Event.fetch_images(body);
    if (fetched != null && fetched != undefined) {
      return fetched;
    } else {
      return [];
    }
  },
};
MemberControl.Sponser = {
  fetch_mainSponser: async ({ body }) => {
    const fetched = await DBController.Member.Sponser.fetch_main_sponser(body);
    if (fetched != null && fetched != undefined) {
      return fetched;
    } else {
      return [];
    }
  },

  fetchSponser: async ({ body }) => {
    const fetched = await DBController.Member.Sponser.fetch_sponser(body);
    if (fetched != null && fetched != undefined) {
      const currentDate = new Date();
      const validSponsors = fetched?.filter(sponsor => {
        const sponserExpiryTime = new Date(sponsor.sponser_expiryTime);
        return sponserExpiryTime > currentDate;
      });
      if (validSponsors.length > 0) {
        return validSponsors;
      } else {
        return [];
      }
    } else {
      return [];
    }
  },
}
MemberControl.Banners = {
  fetchBanners: async ({ body }) => {
    const fetched = await DBController.Member.Banners.fetch_Banners(body);
    if (fetched != null && fetched != undefined && fetched.length != 0) {
      return fetched.map((row) => mapMediaFields(row, ["banner_image"]));
    }
    // Empty is normal on a fresh DB — do not 400 the home screen.
    return [];
  },
}
MemberControl.BloodReq = {
  createBloodReq: async ({ body }) => {
    const fetched = await DBController.Member.BloodReq.createBloodReq(body);
    if (fetched) {
      return "blood request created successfully";
    } else {
      return "failed to create blood request";
    }
  },
  getAllRequest: async ({ body }) => {
    const fetched = await DBController.Member.BloodReq.fetched_requests(body);
    if (fetched != null && fetched != undefined && fetched.length != 0) {
      for (let index = 0; index < fetched.length; index++) {
        fetched[index].createdAt = moment(fetched[index].createdAt).format("DD-MM-YYYY");
      }
      // const filteredData = fetched.filter(item => item.VerifiedBy != null && item.VerifiedBy != undefined && item.VerifiedBy.length != 0);
      // console.log(filteredData);
      // return filteredData;
      return fetched
    } else {
      return [];
    }
  },

  getOneRequest: async ({ body, params }) => {
    const id = params.id;
    const fetched = await DBController.Member.BloodReq.fetch_one_request(id);
    if (fetched != null && fetched != undefined) {
      fetched.createdAt = moment(fetched.createdAt).format("DD-MM-YYYY");
      return fetched;
    } else {
      return [];
    }
  },

};
MemberControl.Folders = {
  fetchedFolders: async ({ body }) => {

    const fetched = await DBController.Member.Folders.fetch_folders(body);
    if (fetched != null && fetched != undefined) {
      return fetched;
    } else {
      return [];
    }
  },
}