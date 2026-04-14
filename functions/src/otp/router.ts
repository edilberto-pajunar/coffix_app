import express from "express";
import * as admin from "firebase-admin";
import { requirePost } from "../middleware/method";
import { AuthenticatedRequest, requiredAuth } from "../middleware/auth";
import { sendEmailOTPSchema, verifyEmailOTPSchema } from "./schemas";
import { firestore } from "../config/firebaseAdmin";
import { createOTPDocumentWithTransaction } from "./service";
import { verifyEmail } from "../user/service";
import { RESEND_FROM_EMAIL } from "../constant/constant";
import FirebaseService from "../firebase/service";
import { otpSendLimiter } from "../middleware/rateLimiter";
import { renderTemplate } from "../utils/renderEmailTemplate";
import { wrapInEmailShell } from "../utils/emailShell";
import { nowNZ } from "../utils/nz_time";

export const otpRouter = express.Router();
otpRouter.use(express.json());

function generateOtp6(): string {
  // 000000 - 999999
  return Math.floor(100000 + Math.random() * 900000)
    .toString()
    .padStart(6, "0");
}

otpRouter.post(
  "/send",
  requirePost,
  requiredAuth,
  otpSendLimiter,
  async (request: AuthenticatedRequest, response) => {
    const validation = sendEmailOTPSchema.safeParse(request.body);
    if (!validation.success) {
      const errors = validation.error.issues
        .map((i) => `${i.path.join(".")}: ${i.message}`)
        .join(", ");
      return response.status(400).json({ success: false, errors });
    }

    const uid = request.user!.uid;
    const email = validation.data.email;

    const otpCode = generateOtp6();
    try {
      const RESEND_API_KEY = process.env.RESEND_API_KEY;

      if (!RESEND_API_KEY) {
        return response.status(500).json({
          success: false,
          message: "Server email configuration missing",
        });
      }

      await firestore.runTransaction(async (transaction) => {
        const pendingSnap = await transaction.get(
          firestore
            .collection("otp")
            .where("userId", "==", uid)
            .where("status", "==", "pending")
            .limit(10),
        );

        pendingSnap.docs.forEach((doc) => {
          transaction.set(
            doc.ref,
            {
              status: "superseded",
            },
            {
              merge: true,
            },
          );
        });

        await createOTPDocumentWithTransaction({
          transaction: transaction,
          otp: otpCode,
          to: email,
          userId: uid,
        });
      });

      // Fetch user document
      const userSnap = await firestore.collection("customers").doc(uid).get();
      if (!userSnap.exists) {
        return response.status(500).json({
          success: false,
          message: "User not found",
        });
      }

      // Fetch OTP email template from Firestore
      const templateSnap = await firestore
        .collection("emails")
        .doc("OTP")
        .get();
      const templateData = templateSnap.data();
      if (!templateData) {
        return response.status(500).json({
          success: false,
          message: "OTP email template not found",
        });
      }

      const subject = renderTemplate(
        (templateData.subject as string) ?? "Your OTP Code",
        {},
      );
      const html = wrapInEmailShell(
        renderTemplate(templateData.content as string, {
          VERIFICATION_CODE: otpCode,
          DATE: nowNZ(),
          EMAIL: email,
        }),
      );

      // Send email AFTER db write (or before—either is fine; this is consistent w/ single active OTP)
      const resendRes = await fetch("https://api.resend.com/emails", {
        method: "POST",
        headers: {
          Authorization: `Bearer ${RESEND_API_KEY}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          from: RESEND_FROM_EMAIL,
          to: [email],
          // bcc: [RESEND_BCC_EMAIL],
          subject,
          html,
        }),
      });

      const resendResult = await resendRes.json();

      if (!resendRes.ok) {
        console.error("Resend API error:", resendResult);
        return response.status(500).json({
          success: false,
          message: "Failed to send email",
        });
      }

      return response.status(200).json({
        success: true,
        message: "OTP sent",
      });
    } catch (e) {
      console.error("Error sending email OTP:", e);
      return response.status(500).json({
        success: false,
        message: "Internal server error",
        error: e,
      });
    }
  },
);

/**
 * POST otp/verify
 *
 *
 */
otpRouter.post(
  "/verify",
  requirePost,
  otpSendLimiter,
  requiredAuth,
  async (request: AuthenticatedRequest, response) => {
    const validation = verifyEmailOTPSchema.safeParse(request.body);
    if (!validation.success) {
      const errors = validation.error.issues
        .map((i) => `${i.path.join(".")}: ${i.message}`)
        .join(", ");
      return response.status(400).json({ success: false, errors });
    }

    const uid = request.user!.uid;
    const submittedOtp = validation.data.otp;

    try {
      // Fetch most recent pending OTP for this user
      const snap = await firestore
        .collection("otp")
        .where("userId", "==", uid)
        .where("status", "==", "pending")
        .orderBy("expirationDate", "desc")
        .limit(1)
        .get();

      if (snap.empty) {
        return response
          .status(400)
          .json({ success: false, message: "No pending OTP found" });
      }

      const docSnap = snap.docs[0];
      const data = docSnap.data();

      const expiresAt = data.expirationDate.toDate().getTime();

      if (expiresAt < Date.now()) {
        return response
          .status(400)
          .json({ success: false, message: "OTP expired" });
      }

      if (data.otp !== submittedOtp) {
        await docSnap.ref.set(
          { attempts: admin.firestore.FieldValue.increment(1) },
          { merge: true },
        );
        return response
          .status(400)
          .json({ success: false, message: "Invalid OTP" });
      }

      await docSnap.ref.set(
        {
          status: "verified",
          verifiedAt: new Date(),
        },
        { merge: true },
      );

      await verifyEmail({ userId: uid });

      // Apply any pending gifts sent to this email before the account existed
      const email: string = data.to;
      const firebaseService = new FirebaseService();
      await firebaseService.applyPendingGifts(uid, email).catch((err) => {
        console.error("Error applying pending gifts:", err);
      });

      return response.status(200).json({
        success: true,
        message: "OTP verified",
      });
    } catch (e) {
      console.log(e);
      return response.status(500).json({
        success: false,
        message: "Internal server error",
      });
    }
  },
);
