import admin from "firebase-admin";
import moment from "moment";
import { createRequire } from "module";
import { DBController } from "../database/DbController.js";


const require = createRequire(import.meta.url);

const firebaseAdmin = admin.initializeApp({
  credential: admin.credential.cert(
    require("../../../config/jci-firebase.json")
  ),
});


export const FirebaseService = {
  /**
   * @name notify
   * @param {*} tokens
   * @param {*} notification
   * @param {*} data
   * @returns
   */

  notify: async (topic, notification, data) => {
    try {
      const notified = await firebaseAdmin.messaging().send({
        notification: notification,
        data: data,
        topic: topic,
      });
      // console.log("notified :>> ", notified);
      return notified;
    } catch (error) {
      console.log(error);
      return null;
    }
  },

  /**
   * @name notifyOnEventCreate
   * @param {*} event_info
   * @returns
   */

  notifyOnEventCreate: async (event_info) => {
    try {
      const notified = await FirebaseService.notify(
        "/topics/events",
        {
          title: "Event: " + event_info.event_name,
          image: event_info.event_image,
          body: "Event_Date: " + event_info.event_date + " and Event_Time: " + event_info.event_time + "\n Click here to view the event",
        },
        {
          route: "events",
          event_id: String(event_info.id),
        }
      );
      return notified;
    } catch (error) {
      return null;
    }
  },
  /**
   * @name notification
   * @param {*} notification
   * @param {*} data
   * @returns
   */
  notification: async (notification) => {
    try {
      const notified = await FirebaseService.notify(
        "/topics/events",
        {
          title: notification.title,
          body: notification.description,
        },
      );
      return notified;
    } catch (error) {
      return null;
    }
  },

  notifyReferral: async ({ fcmToken, referral, referrerName, title, body }) => {
    try {
      if (!fcmToken) return null;
      const referralId = referral?.id || referral?.dataValues?.id;
      return await firebaseAdmin.messaging().send({
        notification: {
          title: title || `New referral from ${referrerName}`,
          body: body || "Tap to view and respond",
        },
        data: {
          route: "referral",
          referral_id: String(referralId),
          type: "referral_received",
        },
        android: {
          priority: "high",
          notification: {
            channelId: "jci_referrals",
            sound: "default",
          },
        },
        apns: {
          payload: {
            aps: { sound: "default", badge: 1 },
          },
        },
        token: fcmToken,
      });
    } catch (error) {
      console.log("notifyReferral error:", error);
      return null;
    }
  },


  notifyEventsThreeDaysBefore: async () => {
    try {
      const threeDaysBefore = moment().subtract(3, 'days').format("DD/MM/YYYY");
      const currentTime = moment().utcOffset(330);
      const eventsFound = await DBController.Member.Event.fetchEventsByDate(threeDaysBefore);

      if (Array.isArray(eventsFound) && eventsFound?.length > 0) {
        return await Promise.all(
          eventsFound.map((event) => {
            const eventTime = moment(event.event_date + " " + event.event_time, "DD/MM/YYYY hh:mm A");
            const timeDifference = moment.duration(eventTime.diff(currentTime)).asHours();

            if (timeDifference > 0 && timeDifference < 24 * 3) { // Check if the event is less than 3 days away
              return event;
            }
          })
        )
          .then(async (events) => {
            if (Array.isArray(events) && events.length > 0) {
              await Promise.all(events.map(async (event) => {
                const title = "Event: " + event.event_name + " coming up in 3 days";
                const body = "Event Date: " + event.event_date + " and Event Time: " + event.event_time + "\nClick here to view the event";

                await FirebaseService.notify(
                  "/topics/events",
                  {
                    title: title,
                    image: event.event_image,
                    body: body,
                  },
                  {
                    route: "events",
                    event_id: String(event.id),
                  }
                );
              }));
            }
          })
          .catch((err) => {
            console.error("Error sending notifications:", err);
            return null;
          });
      }
    } catch (error) {
      console.error("Error retrieving events:", error);
      return null;
    }
  },



  notifyAllEventsBeforeADay: async () => {
    try {
      const tomorrowDate = moment()
        .utcOffset(330)
        .clone()
        .add(1, "day")
        .format("DD/MM/YYYY");
      const event_info = await DBController.Member.Event.fetchEventsByDate(
        tomorrowDate
      );
      if (Array.isArray(event_info) && event_info?.length > 0) {
        var title,
          body = "Click here to view the events";
        if (event_info?.length > 2) {
          title =
            event_info[0]?.event_name +
            "," +
            event_info[1]?.event_name +
            " and more events on tomorrow";
        } else if (event_info?.length === 2) {
          title =
            event_info[0].event_name +
            " and " +
            event_info[1].event_name +
            " events on tomorrow";
        } else if (event_info?.length === 1) {
          title = "Event: " + event_info[0].event_name + " on tomorrow";
          body =
            "Event_Date: " +
            event_info[0].event_date +
            " and Event_Time: " +
            event_info[0].event_time +
            "\n" +
            body;
        }
        await FirebaseService.notify(
          "/topics/events",
          {
            title: title,
            image: event_info[0].event_image,
            body: body,
          },
          {
            route: "events",
            event_id: String(event_info[0].id),
          }
        );
      }
    } catch (error) {
      return null;
    }
  },

  notifyEventsTwoHrBefore: async () => {
    try {
      const todayDate = moment().utcOffset(330).clone().format("DD/MM/YYYY");
      const currentTime = moment(
        moment().utcOffset(330).clone().format("DD/MM/YYYY hh:mm A"),
        "DD/MM/YYYY hh:mm A"
      );
      const eventsFound = await DBController.Member.Event.fetchEventsByDate(
        todayDate
      );
      if (Array.isArray(eventsFound) && eventsFound?.length > 0) {
        return await Promise.all(
          eventsFound.filter((itx) => {
            if (itx?.event_time?.trim()) {
              const event_time = moment(
                moment(
                  itx.event_date + " " + itx.event_time,
                  "DD/MM/YYYY hh:mm A"
                )
                  // .utcOffset(330)
                  .clone()
                  .format("DD/MM/YYYY hh:mm A"),
                "DD/MM/YYYY hh:mm A"
              );
              if (
                moment
                  .duration(event_time.clone().diff(currentTime))
                  .asHours() === 2 &&
                event_time.clone().isAfter(currentTime)
              ) {
                return itx;
              }
            }
          })
        )
          .then(async (event_info) => {
            if (Array.isArray(event_info) && event_info?.length > 0) {
              var title,
                body = "Click here to view the events";
              if (event_info?.length > 2) {
                title =
                  event_info[0]?.event_name +
                  "," +
                  event_info[1]?.event_name +
                  " and more events on 2 hours from now";
              } else if (event_info?.length === 2) {
                title =
                  event_info[0].event_name +
                  " and " +
                  event_info[1].event_name +
                  " events on 2 hours from now";
              } else if (event_info?.length === 1) {
                title =
                  "Event: " + event_info[0].event_name + " on 2 hours from now";
                body =
                  "Event_Date: " +
                  event_info[0].event_date +
                  " and Event_Time: " +
                  event_info[0].event_time +
                  "\n" +
                  body;
              }
              await FirebaseService.notify(
                "/topics/events",
                {
                  title: title,
                  image: event_info[0].event_image,
                  body: body,
                },
                {
                  route: "events",
                  event_id: String(event_info[0].id),
                }
              );
            }
          })
          .catch((err) => {
            return null;
          });
      }
    } catch (error) {
      return null;
    }
  },

  /**
   * @name notifyOnBirthdays
   * @param {*} event_info
   * @returns
   */

  notifyOnTodayBirthdays: async () => {
    try {
      const todayDate = moment().utcOffset(330).clone().format("DD/MM");
      var foundMembers = await DBController.Member.Member.fetchMemberByDob(todayDate);

      if (Array.isArray(foundMembers) && foundMembers?.length > 0) {
        return await Promise.all(
          foundMembers
            .map((iter) => iter?.user_name || "")
            .filter((notNull) => notNull)
        )
          .then(async (birthdayMembers) => {
            if (birthdayMembers?.length > 0) {
              var title;
              var message;
              if (birthdayMembers?.length > 2) {
                title =
                  birthdayMembers[0] +
                  "," +
                  birthdayMembers[1] +
                  " and " +
                  birthdayMembers.length +
                  " others are celebrating their birthdays today 🎂";
                message = "Let them know you're thinking about them";
              } else if (birthdayMembers?.length === 2) {
                title =
                  birthdayMembers[0] +
                  " and " +
                  birthdayMembers[1] +
                  " are celebrating their birthdays today 🎂";
                message = "Let them know you're thinking about them";
              } else if (birthdayMembers?.length === 1) {
                title = "It's " + birthdayMembers[0] + "'s birthday today 🎂";
                var gender;
                console.log("members array : ", foundMembers);
                if (foundMembers[0].gender == "male") {
                  gender = "him";
                }
                if (foundMembers[0].gender == "female") {
                  gender = "her";
                }
                message = "Let " + gender + " know you're thinking about " + gender + "";
              }
              console.log("message : ", message);
              await FirebaseService.notify(
                "/topics/events",
                {
                  title: title,
                  // body: "Let him know you're thinking about him",
                  body: message,
                },
                {
                  route: "birthday",
                }
              );
            }
          })
          .catch((error) => {
            return null;
          });
      }
    } catch (error) {
      return null;
    }
  },

  notifyOnTomorrowBirthdays: async () => {
    try {
      const tomorrowDate = moment()
        .utcOffset(330)
        .clone()
        .add(1, "day")
        .format("DD/MM");
      var foundMembers = await DBController.Member.Member.fetchMemberByDob(
        tomorrowDate
      );
      if (Array.isArray(foundMembers) && foundMembers?.length > 0) {
        return await Promise.all(
          foundMembers
            .map((iter) => iter?.user_name || "")
            .filter((notNull) => notNull)
        )
          .then(async (birthdayMembers) => {
            if (birthdayMembers?.length > 0) {
              var title;
              if (birthdayMembers?.length > 2) {
                title =
                  birthdayMembers[0] +
                  "," +
                  birthdayMembers[1] +
                  " and " +
                  birthdayMembers.length +
                  " others are celebrating their birthdays tomorrow 🎂";
              } else if (birthdayMembers?.length === 2) {
                title =
                  birthdayMembers[0] +
                  " and " +
                  birthdayMembers[1] +
                  " are celebrating their birthdays tomorrow 🎂";
              } else if (birthdayMembers?.length === 1) {
                title =
                  "It's " + birthdayMembers[0] + "'s birthday tomorrow 🎂";
              }
              await FirebaseService.notify(
                "/topics/events",
                {
                  title: title,
                  body: "Let him know you're thinking about him",
                },
                {
                  route: "birthday",
                }
              );
            }
          })
          .catch((err) => {
            return null;
          });
      }
    } catch (error) {
      return null;
    }
  },
};

