import Cron from "node-cron";
import { FirebaseService } from "../lib/firebase.js";

const CronJobFor10clock = Cron.schedule(
  "0 7 * * *",
  async () => {
    await FirebaseService.notifyOnTodayBirthdays();
    // await FirebaseService.notifyOnTomorrowBirthdays();
    // await FirebaseService.notifyAllEventsBeforeADay();
  },
  { timezone: "Asia/Kolkata" }
);

const CronJobFor2hrEvent = Cron.schedule(
  "* * * * *",
  async () => {
    await FirebaseService.notifyEventsTwoHrBefore();
  },
  {
    timezone: "Asia/Kolkata",
  }
);
const CronJobFor3dayEvent = Cron.schedule(
  "* * * * *",
  async () => {
    await FirebaseService.notifyEventsThreeDaysBefore();
  },
  {
    timezone: "Asia/Kolkata",
  }
);

const CronJobForFitnessStories = Cron.schedule(
  "0 * * * *",
  async () => {
    const { FitnessControl } = await import("../inc/controls/FitnessControl.js");
    await FitnessControl.Story.purgeExpired();
  },
  { timezone: "Asia/Kolkata" }
);

export { CronJobFor10clock, CronJobFor2hrEvent, CronJobFor3dayEvent, CronJobForFitnessStories };
