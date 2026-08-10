import { Sequelize } from "sequelize";
import * as config from "../../../config/config.js";
const { database } =
  config.mode === "production" ? config.production : config.development;

if (!database?.db_name || !database?.username) {
  console.error(
    "Missing DB env. Check .env has HS_DB_NAME, HS_DB_HOST, HS_DB_USERNAME, HS_DB_PASSWORD"
  );
  console.error("Loaded:", {
    name: database?.db_name || "(empty)",
    host: database?.host || "(empty)",
    user: database?.username || "(empty)",
    hasPassword: Boolean(database?.password),
  });
  process.exit(1);
}

//Declare & Assign Connection Variables
export const connection = new Sequelize({
  database: database.db_name,
  host: database.host,
  username: database.username,
  password: database.password,
  dialect: "mysql",
  logging: false,
});
export const rootuser = config.defaultuser;
