import express from "express";
// import { Server } from "socket.io";
import http from "http";
import cors from "cors";
import chalk from "chalk";
import path from "path";
import helmet from "helmet";
import * as config from "./config/config.js";
import { routes } from "./src/App/routes/index.js";
import { setup } from "./src/core/setup.js";
import { FirebaseService } from "./src/core/lib/firebase.js";
import {
  CronJobFor10clock,
  CronJobFor2hrEvent,
  CronJobFor3dayEvent,
  CronJobForFitnessStories,
} from "./src/core/utils/cronJob.js";

const __dirname = path.resolve();

const app = express();

CronJobFor10clock.start();
CronJobFor2hrEvent.start();
CronJobFor3dayEvent.start();
CronJobForFitnessStories.start();
//Top level security
app.use(helmet());

//Enable cross origin policy
app.use(
  cors({
    origin: "*",
    optionsSuccessStatus: 200,
    methods: "GET,POST,PUT",
    preflightContinue: false,
    credentials: true,
  })
);
app.set("view engine", "ejs");
app.set("views", "./src/core/views/ui");
app.use(express.static("pages"));
app.use("/images", express.static(path.join(__dirname, "./src/core/images")));

//Parsing incoming requests
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

app.use("/", routes);

app.get("/", async (req, res) => {
  res.status(404).render("404", { message: "Unable to find the requested resource JCI" });
});

app.use(function (req, res, next) {
  res.status(404).render("404", { message: "Unable to find the requested resource JCI" });
});

const AppConfig =
  config.mode === "production" ? config.production : config.development;

setup(AppConfig)
  .then((config) => {
    const port = config.server.port;
    const server = app.listen(port, () => {
      console.log(chalk.yellow(`🚩 JCI Working on the port ${port}`));
    });
    server.on("error", (err) => {
      if (err.code === "EADDRINUSE") {
        console.error(
          chalk.red(
            `Port ${port} is already in use. Run: netstat -ano | findstr :${port} then taskkill /PID <pid> /F`
          )
        );
      } else {
        console.error(chalk.red(err.message || String(err)));
      }
      process.exit(1);
    });
  })
  .catch((error) => {
    console.error(chalk.red(error?.message || String(error)));
    process.exit(1);
  });
