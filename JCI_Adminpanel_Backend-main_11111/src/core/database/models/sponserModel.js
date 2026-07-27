import sequelize from "sequelize";
const { Model, DataTypes } = sequelize;
import { connection } from "../connection.js";

class Sponser extends Model { }

Sponser.init({
    id: {
        type: DataTypes.BIGINT.UNSIGNED,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false,
    },
    sponser_name: {
        type: DataTypes.STRING(255),
        allowNull: false,
    },
    sponser_image: {
        type: DataTypes.STRING(255),
        allowNull: true,
    },
    sponser_contact: {
        type: DataTypes.STRING(255),
        allowNull: false,
    },
    sponser_email: {
        type: DataTypes.STRING(255),
        allowNull: false,
    },
    sponser_description: {
        type: DataTypes.STRING(255),
        allowNull: false,
    },
    sponser_location: {
        type: DataTypes.STRING(255),
        allowNull: false,
    },
    sponser_website: {
        type: DataTypes.STRING(255),
        allowNull: false,
    },
    sponser_expiryTime: {
        type: DataTypes.STRING(255),
        allowNull: false,
    },
    role: {
        type: DataTypes.ENUM("sponser", "main_sponser"),
        allowNull: true,
    },
    status: {
        type: DataTypes.ENUM("active", "inactive"),
        allowNull: false,
        defaultValue: "active",
    },
}, { sequelize: connection, freezeTableName: true });

export { Sponser };