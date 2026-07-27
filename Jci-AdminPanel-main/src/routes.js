import Dashboard from "views/Dashboard.js";
import CreateMember from "views/CreateMember";
import CreateEvent from "views/CreateEvent";
import Memberlist from "views/Memberlist";
import EventList from "views/EventList";
import CreateDesignation from "views/CreateDesignation";
import CreateSponser from "views/CreateSponser";
import SingleMember from "views/SingleMember";
import SingleEvent from "views/SingleEvent";
import CreateFamily from "views/CreateFamily";
import CreateFolder from "views/CreateFolder";
import SponserList from "views/SponserList";
import DonorList from "views/DonorList";

import Event_image_single from "views/Event_image_single";
import Mainsponser from "views/Mainsponser";
import Singlesponserlist from "views/Singlesponserlist";
import Mainsponsersinle from "views/Mainsponsersinle";
import { Redirect } from "react-router-dom";
import CreateRoles from "views/CreateRoles";
import CreateNotification from "views/CreateNotification";
import CreateEventImage from "views/CreateEventImage";
import CreateBusinessCategory from "views/CreateBussinessCategory";
import CreateChannel from "views/CreateChannel";
import CreateBanner from "views/CreateBanner";
import UpdateMember from "views/UpdateMember";
import UpdateEvent from "views/UpdateEvent";
import EditSponser from "views/EditSponser";

const dashboardRoutes = [
  {
    path: "/dashboard",
    name: "Dashboard",
    icon: "nc-icon nc-chart-pie-35",
    iconColor: "#5B8DEF",
    component: Dashboard,
    layout: "/admin",
  },
  {
    path: "/CreateRoles",
    name: "Create Roles",
    icon: "nc-icon nc-badge",
    iconColor: "#F5A623",
    component: CreateRoles,
    layout: "/admin",
  },
  {
    path: "/CreateChannel",
    name: "Green Channel",
    icon: "nc-icon nc-spaceship",
    iconColor: "#2ECC71",
    component: CreateChannel,
    layout: "/admin",
  },
  {
    path: "/CreateBanner",
    name: "Banner",
    icon: "nc-icon nc-album-2",
    iconColor: "#9B59B6",
    component: CreateBanner,
    layout: "/admin",
  },
  {
    path: "/updateMember",
    name: "Update Member",
    sidebar_disable: true,
    icon: "nc-icon nc-circle-09",
    iconColor: "#3498DB",
    component: UpdateMember,
    layout: "/admin",
  },
  {
    path: "/updateEvent/:id",
    name: "Update Event",
    sidebar_disable: true,
    icon: "nc-icon nc-circle-09",
    iconColor: "#E67E22",
    component: UpdateEvent,
    layout: "/admin",
  },
  {
    path: "/EditSponser/:roles/:id",
    name: "Edit Sponser",
    sidebar_disable: true,
    icon: "nc-icon nc-circle-09",
    iconColor: "#1ABC9C",
    component: EditSponser,
    layout: "/admin",
  },
  {
    path: "/CreateMember",
    name: "Create Member",
    icon: "nc-icon nc-circle-09",
    iconColor: "#3498DB",
    component: CreateMember,
    layout: "/admin",
  },

  {
    path: "/CreateFamily",
    name: "Create Family",
    icon: "nc-icon nc-single-02",
    iconColor: "#E91E63",
    component: CreateFamily,
    layout: "/admin",
  },
  {
    path: "/CreateEvent",
    name: "Create Event",
    icon: "nc-icon nc-notes",
    iconColor: "#FF6B6B",
    component: CreateEvent,
    layout: "/admin",
  },

  {
    path: "/CreateDesignation",
    name: "Role Of Honour",
    icon: "nc-icon nc-badge",
    iconColor: "#F1C40F",
    component: CreateDesignation,
    layout: "/admin",
  },
  {
    path: "/CreateEventImage",
    name: "Create Event Image",
    icon: "nc-icon nc-album-2",
    iconColor: "#00BCD4",
    component: CreateEventImage,
    layout: "/admin",
  },

  {
    path: "/CreateBusinessCategory",
    name: "Add Business Type",
    icon: "nc-icon nc-grid-45",
    iconColor: "#8E44AD",
    component: CreateBusinessCategory,
    layout: "/admin",
  },
  {
    path: "/createnotification",
    name: "Create Notification",
    icon: "nc-icon nc-bell-55",
    iconColor: "#FF9800",
    component: CreateNotification,
    layout: "/admin",
  },
  {
    path: "/CreateSponser",
    name: "Create Sponsor",
    icon: "nc-icon nc-single-02",
    iconColor: "#1ABC9C",
    component: CreateSponser,
    layout: "/admin",
  },
  {
    path: "/CreateFolder",
    name: "Create Folder",
    icon: "nc-icon nc-paper-2",
    iconColor: "#795548",
    component: CreateFolder,
    layout: "/admin",
  },
  {
    path: "/Memberlist",
    name: "Member List",
    icon: "nc-icon nc-badge",
    iconColor: "#24B9EC",
    component: Memberlist,
    layout: "/admin",
  },
  {
    path: "/EventList",
    name: "Event List",
    icon: "nc-icon nc-notes",
    iconColor: "#E74C3C",
    component: EventList,
    layout: "/admin",
  },
  {
    path: "/blooddonor",
    name: "Blood request list",
    icon: "nc-icon nc-favourite-28",
    iconColor: "#E53935",
    component: DonorList,
    layout: "/admin",
  },
  {
    path: "/SponserList",
    name: "Sponsor list",
    icon: "nc-icon nc-money-coins",
    iconColor: "#27AE60",
    component: SponserList,
    layout: "/admin",
  },

  {
    path: "/Mainsponser",
    name: "Mainsponsor list",
    icon: "nc-icon nc-bank",
    iconColor: "#2980B9",
    component: Mainsponser,
    layout: "/admin",
  },
  {
    path: "/SingleMember",
    name: "Single Member",
    sidebar_disable: true,
    icon: "nc-icon nc-single-02",
    iconColor: "#3498DB",
    component: SingleMember,
    layout: "/admin",
  },
  {
    path: "/SingleEvent",
    name: "Single Event",
    sidebar_disable: true,
    icon: "nc-icon nc-chart-pie-35",
    iconColor: "#E67E22",
    component: SingleEvent,
    layout: "/admin",
  },
  {
    path: "/Event_image_single",
    name: "Single Event image",
    icon: "nc-icon nc-album-2",
    iconColor: "#00BCD4",
    sidebar_disable: true,
    component: Event_image_single,
    layout: "/admin",
  },
  {
    path: "/Singlesponserlist",
    name: "Sponser singlelist",
    sidebar_disable: true,
    icon: "nc-icon nc-money-coins",
    iconColor: "#27AE60",
    component: Singlesponserlist,
    layout: "/admin",
  },
  {
    path: "/Mainsponsersinle",
    name: "Mainsponser single",
    sidebar_disable: true,
    icon: "nc-icon nc-bank",
    iconColor: "#2980B9",
    component: Mainsponsersinle,
    layout: "/admin",
  },
];

export default dashboardRoutes;
