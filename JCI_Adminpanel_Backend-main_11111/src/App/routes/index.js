import { Router } from "express";
import { memberRouter } from "./memberRoutes.js";
import { Adminroutes } from "../../Admin/routes/adminRoutes.js";

const routes = Router();

routes.use("/member", memberRouter);
routes.use("/jciadmin", Adminroutes);

export { routes };
