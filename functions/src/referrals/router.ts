import express from "express";
import { z } from "zod";
import { requirePost } from "../middleware/method";
import { AuthenticatedRequest, requiredAuth } from "../middleware/auth";
import { firestore } from "../config/firebaseAdmin";
import { AuthService } from "../auth/service";
import { logger } from "firebase-functions/v1";
import { ReferralService } from "./service";

const referralsRouter = express.Router();
referralsRouter.use(express.json());

const sendReferralSchema = z.object({
  recipients: z
    .array(
      z.object({
        email: z.email(),
        name: z.string().min(1),
      }),
    )
    .min(1),
});

referralsRouter.post(
  "/send",
  requirePost,
  requiredAuth,
  async (request: AuthenticatedRequest, response) => {
    const validation = sendReferralSchema.safeParse(request.body);
    if (!validation.success) {
      const errors = validation.error.issues
        .map((i) => `${i.path.join(".")}: ${i.message}`)
        .join(", ");
      return response.status(400).json({ success: false, errors });
    }

    const uid = request.user!.uid;
    const { recipients } = validation.data;

    try {
      // Check which emails are already registered
      const authService = new AuthService();
      const existenceChecks = await Promise.all(
        recipients.map(async (recipient) => ({
          ...recipient,
          exists: await authService.customerHasAccount({
            email: recipient.email,
          }),
        })),
      );

      const existingEmails = existenceChecks
        .filter((r) => r.exists)
        .map((r) => r.email);

      if (existingEmails.length > 0) {
        return response.status(400).json({
          success: false,
          message: `The following emails are already registered: ${existingEmails.join(", ")}`,
        });
      }

      // Check for existing pending referrals for these emails
      const emails = recipients.map((r) => r.email);
      const pendingSnaps = await Promise.all(
        emails.map((email) =>
          firestore
            .collection("referrals")
            .where("referee", "==", email)
            .where("status", "in", ["pending", "active"])
            .limit(1)
            .get(),
        ),
      );

      const alreadyReferredEmails = emails.filter(
        (_, i) => !pendingSnaps[i].empty,
      );

      if (alreadyReferredEmails.length > 0) {
        return response.status(400).json({
          success: false,
          message: `The following emails already have a pending referral: ${alreadyReferredEmails.join(", ")}`,
        });
      }

      // Create referral documents and send emails in parallel
      const referralService = new ReferralService();
      await Promise.all(
        existenceChecks.map(async ({ email, name }) => {
          await referralService.createReferral({
            referrerUid: uid,
            referee: { email, name },
          });
          await referralService.sendReferralEmail({
            referrerUid: uid,
            referee: { email, name },
          });
        }),
      );

      return response.status(200).json({
        success: true,
        message: "Referral sent",
      });
    } catch (e) {
      logger.error("Error sending referral:", e);
      return response.status(500).json({
        success: false,
        message: "Internal server error",
        error: e,
      });
    }
  },
);

export default referralsRouter;
