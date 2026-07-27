import sequelize from "sequelize";
const { Model, DataTypes } = sequelize;
import { connection } from "../connection.js";

class Admin extends Model { }

Admin.init({
    id: {
        type: DataTypes.BIGINT.UNSIGNED,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false,
    },
    email_id: {
        type: DataTypes.STRING(255),
        allowNull: false,
    },
    phone: {
        type: DataTypes.STRING(255),
        allowNull: false,
    },
    username: {
        type: DataTypes.STRING(255),
        allowNull: false,
    },
    password: {
        type: DataTypes.STRING(255),
        allowNull: false,
    },
    user_type: {
        type: DataTypes.ENUM("ROOT", "USER"),
        allowNull: false,
        defaultValue: "USER",
    },
    status: {
        type: DataTypes.ENUM("active", "inactive", "terminated"),
        allowNull: false,
        defaultValue: "active",
    },
}, { sequelize: connection, freezeTableName: true });

class Banners extends Model { }

Banners.init({
    id: {
        type: DataTypes.BIGINT.UNSIGNED,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false,
    },
    banner_image: {
        type: DataTypes.STRING(255),
        allowNull: false,
    },
    // status: {
    //     type: DataTypes.ENUM("active", "inactive", "terminated"),
    //     allowNull: false,
    //     defaultValue: "active",
    // },
}, { sequelize: connection, freezeTableName: true });

class userRoles extends Model { }

userRoles.init({
    id: {
        type: DataTypes.BIGINT.UNSIGNED,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false,
    },
    role_name: {
        type: DataTypes.STRING(255),
        allowNull: false,
    },
}, { sequelize: connection, freezeTableName: true });

export { Admin, userRoles, Banners };