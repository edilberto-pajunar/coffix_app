import express, { Response } from "express";
import { requiredAuth, type AuthenticatedRequest } from "../middleware/auth";
import { requirePost } from "../middleware/method";
import { createPaymentSessionBodySchema } from "./schema";

import { WindcaveService } from "./service";
import { logger } from "firebase-functions";
import { WindcaveError } from "../utils/windcave.error";
import FirebaseService from "../firebase/service";

const router = express.Router();

router.post(
  "/session",
  requirePost,
  requiredAuth,
  async (request: AuthenticatedRequest, response: Response) => {
    const firebaseService = new FirebaseService();
    const windcaveService = new WindcaveService();
    const customerId = request.user?.uid;

    if (!customerId) {
      return response
        .status(401)
        .json({ success: false, message: "Unauthorized" });
    }

    try {
      const validation = createPaymentSessionBodySchema.safeParse(request.body);
      let totalAmount = 0;
      if (!validation.success) {
        const errors = validation.error.issues
          .map((i) => `${i.path.join(".")}: ${i.message}`)
          .join(", ");
        return response.status(400).json({ success: false, errors });
      }
      totalAmount = await windcaveService.computeOrderTotal({
        items: validation.data.items,
      });

      const orderId = await firebaseService.createNewOrder({
        amount: totalAmount,
        customerId,
        storeId: validation.data.storeId,
        items: validation.data.items,
        scheduledAt: validation.data.scheduledAt,
      });

      logger.info("Total amount:", totalAmount);

      const { paymentSessionUrl, sessionId } = await windcaveService.createPaymentSession(
        {
          amount: totalAmount,
          orderId,
        },
      );

      await firebaseService.createNewTransaction({
        customerId,
        orderId,
        amount: totalAmount,
        sessionId,
      });

      return response.status(200).json({ success: true, data: { paymentSessionUrl } });
    } catch (error) {
      if (error instanceof WindcaveError) {
        return response
          .status(error.status)
          .json({ success: false, message: error.message, data: error.data });
      }
      logger.error("Error creating payment session:", error);
      return response
        .status(500)
        .json({ success: false, message: "Internal server error" });
    }
  },
);

export default router;
