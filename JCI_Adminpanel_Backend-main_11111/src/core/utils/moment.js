import moment from "moment";
moment.suppressDeprecationWarnings = true;

export const validDateFormat = async (inpDate) => {

  const dateFormat = "DD/MM/YYYY";
  const toDateFormat = moment(new Date(inpDate)).clone().format(dateFormat);

  if (moment(toDateFormat, dateFormat, true).isValid()) {

    return moment(inpDate).format("DD/MM/YYYY");
  } else {
    return false;
  }
};

// export const convertDateToIST = async (inpDate) => {
//   const dateFormat = "DD/MM/YYYY, h:mm:ss";
//   return moment(inpDate).clone().format(dateFormat);
// };

export const convertDateToIST = async (inpDate) => {
  return moment(inpDate).utcOffset(330).format("DD/MM/YYYY hh:mm A");
};

export const convert24HrTo12Hr = async (inpTime) => {
  return moment(inpTime, "HH:mm").format("hh:mm A");
};
