import express, { Response } from "express";
import { requiredAuth, type AuthenticatedRequest } from "../middleware/auth";
import { requirePost } from "../middleware/method";
import FirebaseService from "../firebase/service";
import { WindcaveService } from "../windcave/service";
import { WindcaveError } from "../utils/windcave.error";
import { logger } from "firebase-functions";
import { getTopupMerchantReference } from "./utils";
import {
  CoffixCreditService,
  InsufficientCreditError,
  MinCreditError,
} from "./service";
import { shareCoffixCreditSchema, topupBodySchema } from "./schema";
import { generateTransactionNumber } from "../utils/generate_order_number";
import { creditLimiter } from "../middleware/rateLimiter";
import { addLog } from "../log/service";

const router = express.Router();

router.post(
  "/topup",
  requirePost,
  requiredAuth,
  async (request: AuthenticatedRequest, response: Response) => {
    const customerId = request.user?.uid;
    if (!customerId) {
      return response
        .status(401)
        .json({ success: false, message: "Unauthorized" });
    }

    const firebaseService = new FirebaseService();
    const windcaveService = new WindcaveService();

    try {
      const validation = topupBodySchema.safeParse(request.body);
      if (!validation.success) {
        const errors = validation.error.issues
          .map((i) => `${i.path.join(".")}: ${i.message}`)
          .join(", ");
        return response.status(400).json({ success: false, errors });
      }

      const userDoc = await firebaseService.findUserByCustomerId(customerId);
      if (!userDoc) {
        return response
          .status(401)
          .json({ success: false, message: "Unauthorized" });
      }

      const { amount } = validation.data;
      const merchantReference = getTopupMerchantReference(customerId);
      void addLog({
        category: "purchase",
        severityLevel: "info",
        action: "Add Coffix Credit to customer",
        notes: `Amount: ${amount}`,
        customerId,
      });

      const { paymentSessionUrl, sessionId } =
        await windcaveService.createPaymentSession({
          amount,
          merchantReference,
          userDoc: userDoc,
        });

      const transactionNumber = await generateTransactionNumber();

      const transaction = await firebaseService.createTopupTransaction({
        customerId,
        amount,
        sessionId,
        transactionNumber,
      });

      const data = { paymentSessionUrl, transaction };

      logger.info("Transaction created:", data);

      return response.status(200).json({
        success: true,
        data,
      });
    } catch (error) {
      if (error instanceof WindcaveError) {
        return response
          .status(error.status)
          .json({ success: false, message: error.message, data: error.data });
      }
      logger.error("Error creating topup session:", error);
      void addLog({
        category: "purchase",
        severityLevel: "error",
        action: "Failed to add Coffix Credit to customer",
        notes: `Error: ${error.message}`,
        customerId,
      });
      return response
        .status(500)
        .json({ success: false, message: "Internal server error" });
    }
  },
);

router.post(
  "/share",
  creditLimiter,
  requiredAuth,
  requirePost,
  async (request: AuthenticatedRequest, response: Response) => {
    const senderId = request.user?.uid;
    if (!senderId) {
      return response
        .status(401)
        .json({ success: false, message: "Unauthorized" });
    }

    const validation = shareCoffixCreditSchema.safeParse(request.body);
    if (!validation.success) {
      const errors = validation.error.issues
        .map((i: any) => `${i.path.join(".")}: ${i.message}`)
        .join(", ");
      return response.status(400).json({ success: false, errors });
    }

    const firebaseService = new FirebaseService();
    const creditService = new CoffixCreditService();

    try {
      const senderDoc = await firebaseService.findUserByCustomerId(senderId);
      if (!senderDoc) {
        return response
          .status(401)
          .json({ success: false, message: "Unauthorized" });
      }

      void addLog({
        category: "purchase",
        severityLevel: "info",
        action: "Share Coffix Credit to customer",
        notes: `Amount: ${validation.data.amount}`,
        customerId: senderId,
      });

      const { recipientFirstName, recipientLastName, recipientEmail, amount } =
        validation.data;

      if (
        senderDoc.email &&
        senderDoc.email.toLowerCase() === recipientEmail.toLowerCase()
      ) {
        return response.status(400).json({
          success: false,
          message: "You cannot share credit to your own account",
        });
      }

      await creditService.shareCredit({
        senderId,
        senderFirstName: senderDoc.firstName ?? "",
        senderLastName: senderDoc.lastName ?? "",
        recipientFullName: `${recipientFirstName} ${recipientLastName}`,
        recipientEmail,
        amount,
      });

      return response.status(200).json({ success: true });
    } catch (error) {
      void addLog({
        category: "purchase",
        severityLevel: "error",
        action: "Failed to share Coffix Credit to customer",
        notes: `Error: ${error.message}`,
        customerId: senderId,
      });
      if (error instanceof InsufficientCreditError) {
        return response.status(400).json({
          success: false,
          message: "Insufficient credit",
          data: {
            creditAvailable: error.creditAvailable,
            required: error.required,
          },
        });
      }
      if (error instanceof MinCreditError) {
        return response.status(400).json({
          success: false,
          message: `Amount must be at least ${error.min}`,
          data: { min: error.min },
        });
      }
      logger.error("Error sharing credit:", error);
      return response
        .status(500)
        .json({ success: false, message: "Internal server error" });
    }
  },
);

router.post(
  "/expire",
  requirePost,
  async (request: AuthenticatedRequest, response: Response) => {
    const secret = request.headers["x-cron-secret"];
    if (!secret || secret !== process.env.CRON_SECRET) {
      return response
        .status(401)
        .json({ success: false, message: "Unauthorized" });
    }

    const firebaseService = new FirebaseService();
    try {
      const { expiredCount } = await firebaseService.expireCredits();
      void addLog({
        category: "purchase",
        severityLevel: "info",
        action: "Scheduled Every Day at 00:00 to expire Coffix Credit",
        notes: `Expired ${expiredCount} customers`,
      });
      logger.info(`Credit expiry run: ${expiredCount} customers expired`);
      return response
        .status(200)
        .json({ success: true, data: { expiredCount } });
    } catch (error) {
      logger.error("Error expiring credits:", error);
      return response
        .status(500)
        .json({ success: false, message: "Internal server error" });
    }
  },
);

export default router;
