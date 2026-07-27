import nodemailer from "nodemailer";
import { smtp_config } from "../../../config/config.js";

let transporter = null;

const getTransporter = () => {
  if (!smtp_config.user || !smtp_config.pass) {
    return null;
  }
  if (!transporter) {
    transporter = nodemailer.createTransport({
      service: "gmail",
      auth: {
        user: smtp_config.user,
        pass: smtp_config.pass,
      },
    });
  }
  return transporter;
};

export const MailerService = {
  sendPasswordResetEmail: async ({ to, resetToken, memberName }) => {
    const transport = getTransporter();
    if (!transport) {
      console.log("[mailer] SMTP not configured — reset token:", resetToken);
      return { sent: false, token: resetToken };
    }
    await transport.sendMail({
      from: smtp_config.from,
      to,
      subject: "JCI GreenCity — Reset your password",
      html: `
        <p>Hi ${memberName || "Member"},</p>
        <p>Your password reset code: <strong>${resetToken}</strong></p>
        <p>Open the JCI app and enter this code on the reset screen. Expires in 1 hour.</p>
      `,
      text: `Reset code: ${resetToken}`,
    });
    return { sent: true };
  },
};
