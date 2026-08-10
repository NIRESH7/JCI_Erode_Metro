import { DataTypes, Model } from "sequelize";
import { connection } from "../connection.js";

class MemberNotification extends Model {}

MemberNotification.init(
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
    type: {
      type: DataTypes.ENUM(
        "referral_received",
        "referral_viewed",
        "referral_responded"
      ),
      allowNull: false,
    },
    title: {
      type: DataTypes.STRING(255),
      allowNull: false,
    },
    body: {
      type: DataTypes.STRING(512),
      allowNull: false,
    },
    referral_id: {
      type: DataTypes.BIGINT.UNSIGNED,
      allowNull: true,
    },
    actor_member_id: {
      type: DataTypes.BIGINT.UNSIGNED,
      allowNull: true,
    },
    is_read: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
      defaultValue: false,
    },
  },
  { sequelize: connection, freezeTableName: true }
);

export { MemberNotification };
