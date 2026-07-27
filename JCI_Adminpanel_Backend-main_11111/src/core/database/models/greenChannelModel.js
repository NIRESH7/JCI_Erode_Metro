import sequelize from "sequelize";
const { Model, DataTypes } = sequelize;
import { connection } from "../connection.js";

class GreenChannel extends Model {}

GreenChannel.init(
  {
    id: {
      type: DataTypes.BIGINT.UNSIGNED,
      primaryKey: true,
      autoIncrement: true,
      allowNull: false,
    },
    pdf_url: {
      type: DataTypes.TEXT,
      allowNull: false,
      defaultValue: "",
    },
    pdf_name: {
      type: DataTypes.TEXT,
      allowNull: true,
    },
  },
  { sequelize: connection, freezeTableName: true }
);

export { GreenChannel };
