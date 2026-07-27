import sequelize from "sequelize";
const { Model, DataTypes } = sequelize;
import { connection } from "../connection.js";

class Member extends Model { }

Member.init(
  {
    id: {
      type: DataTypes.BIGINT.UNSIGNED,
      primaryKey: true,
      autoIncrement: true,
      allowNull: true,
    },
    profile_pic: {
      type: DataTypes.STRING(255),
      allowNull: true,
    },
    user_name: {
      type: DataTypes.STRING(255),
      allowNull: true,
    },
    membership_id: {
      type: DataTypes.STRING(255),
      allowNull: true,
    },
    email: {
      type: DataTypes.STRING(255),
      allowNull: true,
    },
    contact: {
      type: DataTypes.STRING(255),
      allowNull: true,
    },
    gender: {
      type: DataTypes.ENUM("male", "female", "others"),
      allowNull: true,
      defaultValue: "male",
    },
    dob: {
      type: DataTypes.STRING(15),
      allowNull: true,
    },
    location: {
      type: DataTypes.TEXT,
      allowNull: true,
    },
    blood_group: {
      type: DataTypes.ENUM(
        "O+",
        "O-",
        "A+",
        "A-",
        "B+",
        "B-",
        "AB+",
        "AB-",
        "A1+",
        "A2+",
        "A1B+",
        "A1B-",
        "A2B+",
        "HH"
      ),
      allowNull: true,
    },
    willing_to_donate: {
      type: DataTypes.ENUM("yes", "no"),
      allowNull: true,
    },
    office_name: {
      type: DataTypes.STRING(255),
      allowNull: true,
    },
    job: {
      type: DataTypes.STRING(255),
      allowNull: true,
    },
    sector: {
      type: DataTypes.STRING(255),
      allowNull: true,
    },
    martial_status: {
      type: DataTypes.STRING(255),
      allowNull: true,
    },
    role: {
      type: DataTypes.STRING(255),
      allowNull: true,
    },
    jci_location: {
      type: DataTypes.STRING(255),
      allowNull: true,
    },
    type: {
      type: DataTypes.ENUM("member", "boardmember"),
      allowNull: true,
      defaultValue: "member",
    },
    status: {
      type: DataTypes.ENUM("active", "inactive"),
      allowNull: true,
      defaultValue: "active",
    },
    app_access: {
      type: DataTypes.ENUM("view", "full"),
      allowNull: false,
      defaultValue: "view",
    },
  },
  { sequelize: connection, freezeTableName: true }
);

class Family extends Model { }

Family.init(
  {
    id: {
      type: DataTypes.BIGINT.UNSIGNED,
      primaryKey: true,
      autoIncrement: true,
      allowNull: true,
    },
    member_id: {
      type: DataTypes.BIGINT.UNSIGNED,
      allowNull: true,
    },
    name: {
      type: DataTypes.STRING(255),
      allowNull: true,
    },
    dob: {
      type: DataTypes.STRING(255),
      allowNull: true,
    },

    anniversary: {
      type: DataTypes.STRING(20),
      allowNull: true,
    },
    blood_group: {
      type: DataTypes.ENUM(
        "O+",
        "O-",
        "A+",
        "A-",
        "B+",
        "B-",
        "AB+",
        "AB-",
        "A1+",
        "A2+",
        "A1B+",
        "A1B-",
        "A2B+",
        "HH"
      ),
      allowNull: true,
    },
    relationship: {
      type: DataTypes.STRING(255),
      allowNull: true,

    },
  },
  { sequelize: connection, freezeTableName: true }
);

class Designation extends Model { }

Designation.init(
  {
    id: {
      type: DataTypes.BIGINT.UNSIGNED,
      primaryKey: true,
      autoIncrement: true,
      allowNull: false,
    },
    member_id: {
      type: DataTypes.BIGINT.UNSIGNED,
      allowNull: false,
    },
    designation_name: {
      type: DataTypes.STRING(255),
      allowNull: false,
    },
    designation_year: {
      type: DataTypes.STRING(255),
      allowNull: false,
    },
  },
  { sequelize: connection, freezeTableName: true }
);

class roleOfHonour extends Model { }

roleOfHonour.init(
  {
    id: {
      type: DataTypes.BIGINT.UNSIGNED,
      primaryKey: true,
      autoIncrement: true,
      allowNull: false,
    },
    member_id: {
      type: DataTypes.BIGINT.UNSIGNED,
      allowNull: false,
    },
    role_of_honour_year: {
      type: DataTypes.STRING(255),
      allowNull: false,
    },
  },
  { sequelize: connection, freezeTableName: true }
);

class boardMembers extends Model { }

boardMembers.init(
  {
    id: {
      type: DataTypes.BIGINT.UNSIGNED,
      primaryKey: true,
      autoIncrement: true,
      allowNull: false,
    },
    member_id: {
      type: DataTypes.BIGINT.UNSIGNED,
      allowNull: false,
    },
  },
  { sequelize: connection, freezeTableName: true }
);
class BloodReq extends Model { }

BloodReq.init(
  {
    id: {
      type: DataTypes.BIGINT.UNSIGNED,
      primaryKey: true,
      autoIncrement: true,
      allowNull: false,
    },
    NameOfPatient: {
      type: DataTypes.STRING(255),
      allowNull: false,
    },
    BloodGroup: {
      type: DataTypes.STRING(255),
      allowNull: false,
    },
    NoOfUnits: {
      type: DataTypes.STRING(255),
      allowNull: false,
    },
    Hospital_name: {
      type: DataTypes.STRING(255),
      allowNull: false,
    },
    location: {
      type: DataTypes.STRING(255),
      allowNull: false,
    },
    Contact: {
      type: DataTypes.STRING(255),
      allowNull: false,
    },
    Attender: {
      type: DataTypes.STRING(255),
      allowNull: false,
    },
    // date: {
    //   type: DataTypes.DATEONLY,
    //   allowNull: false,
    // },
    created_by: {
      type: DataTypes.STRING(255),
      allowNull: true,
      defaultValue: '',
      field: 'VerifiedBy',
    },
  },
  { sequelize: connection, freezeTableName: true }
);
class BusinessType extends Model { }

BusinessType.init({
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  Business_name: {
    type: DataTypes.STRING(255),
    allowNull: false,
  },
  parent_Id: {
    type: DataTypes.INTEGER,
    allowNull: true,
    defaultValue: 0

  },
}, { sequelize: connection, freezeTableName: true });


class notification extends Model { }

notification.init(
  {
    id: {
      type: DataTypes.BIGINT.UNSIGNED,
      primaryKey: true,
      autoIncrement: true,
      allowNull: false,
    },
    title: {
      type: DataTypes.STRING(255),
      allowNull: false,
    },
    description: {
      type: DataTypes.STRING(255),
      allowNull: false,
    },
    notification_type: {
      type: DataTypes.ENUM("member", "boardmember"),
      allowNull: false,
    },

  },
  { sequelize: connection, freezeTableName: true }
);

class folderName extends Model { }

folderName.init(
  {
    id: {
      type: DataTypes.BIGINT.UNSIGNED,
      primaryKey: true,
      autoIncrement: true,
      allowNull: false,
    },
    folderName: {
      type: DataTypes.STRING(255),
      allowNull: false,
    },
    title: {
      type: DataTypes.STRING(255),
      allowNull: false,
    },
    description: {
      type: DataTypes.STRING(255),
      allowNull: false,
    },
    image: {
      type: DataTypes.TEXT,
      allowNull: false,
    },
    status: {
      type: DataTypes.ENUM("active", "inactive"),
      allowNull: false,
      defaultValue: "active",
    },


  },
  { sequelize: connection, freezeTableName: true }
);
export { Member, Designation, Family, roleOfHonour, boardMembers, BloodReq, BusinessType, notification, folderName };
