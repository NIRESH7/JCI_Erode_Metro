import * as models from "./models/index.js";
import { connection } from "./connection.js";
import { DBController } from "./DbController.js";
import { rootuser } from "./connection.js";

export const modelAssociations = async () => {
  // user
  models.roleOfHonour.belongsTo(models.Member, {
    sourceKey: "id",
    foreignKey: "member_id",
  });
  models.Designation.belongsTo(models.Member, {
    sourceKey: "id",
    foreignKey: "member_id",
  });
  models.boardMembers.belongsTo(models.Member, {
    sourceKey: "id",
    foreignKey: "member_id",
  });
};

//Check connection
export const dbConnection = async () => {
  return await connection.authenticate();
};

export const dbSync = async () => {
  //table associations
  await modelAssociations();

  //sync all Db Models
  await Promise.all(Object.values(models));
  //Create Db Models
  await connection.sync({ force: false });
};
