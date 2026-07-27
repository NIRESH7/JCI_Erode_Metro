import sequelize from "sequelize";
const { Model, DataTypes } = sequelize;
import { connection } from "../connection.js";

class Events extends Model {}

Events.init({
    id: {
        type: DataTypes.BIGINT.UNSIGNED,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false,
    },
    event_name: {
        type: DataTypes.STRING(255),
        allowNull: false,
    },
    event_image: {
        type: DataTypes.STRING(255),
        allowNull: false,
    },
    event_date: {
        type: DataTypes.STRING(255),
        allowNull: false,
    },
    event_time: {
        type: DataTypes.STRING(255),
        allowNull: false,
    },
    event_location: {
        type: DataTypes.STRING(255),
        allowNull: false,
    },
    event_desc: {
        type: DataTypes.TEXT,
        allowNull: false,
    },
}, { sequelize: connection, freezeTableName: true });

class eventsImage extends Model {}

eventsImage.init({
    id: {
        type: DataTypes.BIGINT.UNSIGNED,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false,
    },
    event_id: {
        type: DataTypes.BIGINT.UNSIGNED,
        allowNull: false,
    },
    event_name: {
        type: DataTypes.STRING(255),
        allowNull: false,
    },
    event_image: {
        type: DataTypes.STRING(255),
        allowNull: false,
    },
    status: {
        type: DataTypes.ENUM("active", "inactive", "terminated"),
        allowNull: false,
        defaultValue: "active",
    },
}, { sequelize: connection, freezeTableName: true });

export { Events, eventsImage };