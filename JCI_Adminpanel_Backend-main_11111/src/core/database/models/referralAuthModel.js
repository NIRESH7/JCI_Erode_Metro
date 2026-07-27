import sequelize from "sequelize";
const { Model, DataTypes } = sequelize;
import { connection } from "../connection.js";

class MemberAuth extends Model {}

MemberAuth.init(
  {
    id: {
      type: DataTypes.BIGINT.UNSIGNED,
      primaryKey: true,
      autoIncrement: true,
    },
    member_id: {
      type: DataTypes.BIGINT.UNSIGNED,
      allowNull: false,
      unique: true,
    },
    password_hash: {
      type: DataTypes.STRING(255),
      allowNull: true,
    },
    google_id: {
      type: DataTypes.STRING(255),
      allowNull: true,
      unique: true,
    },
    login_email: {
      type: DataTypes.STRING(255),
      allowNull: true,
    },
    login_phone: {
      type: DataTypes.STRING(50),
      allowNull: true,
    },
    is_setup_complete: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
      defaultValue: false,
    },
  },
  { sequelize: connection, freezeTableName: true }
);

class PasswordResetToken extends Model {}

PasswordResetToken.init(
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
    token_hash: {
      type: DataTypes.STRING(255),
      allowNull: false,
    },
    type: {
      type: DataTypes.ENUM("email_link", "identity_verify"),
      allowNull: false,
    },
    expires_at: {
      type: DataTypes.DATE,
      allowNull: false,
    },
    used: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
      defaultValue: false,
    },
  },
  { sequelize: connection, freezeTableName: true }
);

class MemberSession extends Model {}

MemberSession.init(
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
    fcm_token: {
      type: DataTypes.STRING(512),
      allowNull: true,
      unique: true,
    },
    device_info: {
      type: DataTypes.STRING(255),
      allowNull: true,
    },
    last_active: {
      type: DataTypes.DATE,
      allowNull: true,
    },
  },
  { sequelize: connection, freezeTableName: true }
);

class Referral extends Model {}

Referral.init(
  {
    id: {
      type: DataTypes.BIGINT.UNSIGNED,
      primaryKey: true,
      autoIncrement: true,
    },
    referrer_member_id: {
      type: DataTypes.BIGINT.UNSIGNED,
      allowNull: false,
    },
    linked_member_id: {
      type: DataTypes.BIGINT.UNSIGNED,
      allowNull: true,
    },
    referral_type: {
      type: DataTypes.ENUM("self", "jci_member", "non_jci_member"),
      allowNull: false,
    },
    referred_name: {
      type: DataTypes.STRING(255),
      allowNull: false,
    },
    referred_phone: {
      type: DataTypes.STRING(50),
      allowNull: false,
    },
    remark: {
      type: DataTypes.TEXT,
      allowNull: true,
    },
    referred_member_id: {
      type: DataTypes.BIGINT.UNSIGNED,
      allowNull: true,
    },
    status: {
      type: DataTypes.ENUM("pending", "accepted", "rejected"),
      allowNull: false,
      defaultValue: "pending",
    },
    connection_type: {
      type: DataTypes.ENUM("non_closed_connect", "completed"),
      allowNull: true,
    },
    connect_amount: {
      type: DataTypes.DECIMAL(12, 2),
      allowNull: true,
    },
  },
  { sequelize: connection, freezeTableName: true }
);

export { MemberAuth, PasswordResetToken, MemberSession, Referral };
