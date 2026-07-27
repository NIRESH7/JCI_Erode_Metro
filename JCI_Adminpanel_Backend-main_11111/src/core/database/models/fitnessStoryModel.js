import { DataTypes, Model } from "sequelize";
import { connection } from "../connection.js";

class FitnessStory extends Model {}

FitnessStory.init(
  {
    id: {
      type: DataTypes.BIGINT.UNSIGNED,
      primaryKey: true,
      autoIncrement: true,
    },
    member_id: {
      type: DataTypes.BIGINT.UNSIGNED,
      allowNull: false,
    },
    image_path: {
      type: DataTypes.STRING(512),
      allowNull: false,
    },
    expires_at: {
      type: DataTypes.DATE,
      allowNull: false,
    },
  },
  { sequelize: connection, freezeTableName: true }
);

export { FitnessStory };
