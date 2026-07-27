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
  dbSync();
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
