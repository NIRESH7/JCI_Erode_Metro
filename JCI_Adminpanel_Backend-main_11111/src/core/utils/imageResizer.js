import require from "requirejs";
import fs from "fs";
import shelljs from "shelljs";
const path = require("path");
const express = require("express");
const multer = require("multer");
const cors = require("cors");
const sharp = require("sharp");
const __dirname = path.resolve();

const fileStorageEngine = multer.diskStorage({
  //original resource storage
  destination: (req, file, cb) => {
    if (!fs.existsSync(__dirname + "/src/core/images/original")) {
      shelljs.mkdir("-p", __dirname + "/src/core/images/original");
      // fs.openSync(__dirname + "/src/core/images/original/.gitkeep", "Wa");
    }
    cb(null, "./src/core/images/original"); //directory
  },
  filename: (req, file, cb) => {
    const ext = path.extname(file.originalname)?.toLowerCase();
    cb(null, file.originalname);
  },
});

const upload = multer({
  storage: fileStorageEngine,
  limits: {
    fileSize: 15 * 1024 * 1024, //15mb — phone gallery photos are often 5MB+
  },
  fileFilter: function (req, file, callback) {
    checkFileType(file, callback);
  },
});
function checkFileType(file, callback) {
  const filetypes = /jpg|jpeg|png|svg|pdf|webp|heic|heif/;
  const extname = filetypes.test(
    path.extname(file.originalname)?.toLowerCase()
  );
  const mimetype = filetypes.test(file.mimetype);

  // Accept when MIME type matches (Android gallery files often lack an extension).
  if (mimetype || extname) {
    return callback(null, true);
  }
  callback("Unsupported file type. Use JPG, PNG, or WEBP.");
}

export const Resizer = async (req, res, next) => {
  // console.log(image);
  upload.single("image")(req, res, async function (error) {
    if (error) {
      return res.status(400).json({
        Error: error.message,
      });
    } else {
      // req.image = req?.file?.path || "";
      req.image = req?.file?.path || null;
      if (req.image) {
        // Always save as JPEG so file extension matches actual image bytes.
        const imagename = "JCI" + Date.now() + ".jpg";
        const compressedImage = path.join(
          __dirname,
          "/src/core/images/",
          imagename
        );
        await sharp(req.image)
          .resize(500)
          .jpeg({
            quality: 80,
            mozjpeg: true,
          })
          .toFile(compressedImage);
        const fileCreated = fs.existsSync(
          path.join(__dirname, "/src/core/images/", imagename)
        );
        if (fileCreated) {
          req.image = process.env.HS_IMAGE + "/images/" + imagename;
        } else {
          return "Failed to upload the image";
        }
      }
    }
    next();
  });
};

export const uploadGreenChannelPdf = async (req, res, next) => {
  upload.single("greenChannel")(req, res, async function (error) {
    if (error) {
      return res.json({
        Error: error.message,
      });
    } else {
      req.image = {};
      if (req.file) {
        req.image = {
          pdf_url:
            process.env.HS_IMAGE + "/images/original/" + req.file.originalname,
        };
      } else {
        return res.json({
          Error: "No pdf selected",
        });
      }
    }
    next();
  });
};
