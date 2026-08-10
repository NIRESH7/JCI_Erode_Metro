import chalk from "chalk";
import { dbConnection, dbSync } from "./database/initialize.js";
import { Logger } from "./lib/logger.js";

//Execute Table
export const setup = async (gloablConfig) => {
  await processBlock(
    dbConnection,
    chalk.green("Db connected successfully"),
    "Db connection failed"
  );
  try {
    await dbSync();
  } catch (error) {
    Logger.error("Db sync failed (server still starting)");
    console.error("DB Sync details:", error?.message || error);
  }
  return gloablConfig;
};

const processBlock = async (func, successTxt, errorTxt) => {
  try {
    await func();
    Logger.info(successTxt);
  } catch (error) {
    Logger.error(errorTxt);
    console.error("DB Error details:", error?.message || error);
    throw new Error(error);
  }
};
