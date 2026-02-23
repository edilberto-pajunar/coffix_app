import express, { Response } from "express";
import { requiredAuth, type AuthenticatedRequest } from "../middleware/auth";
import { requirePost } from "../middleware/method";
import { createPaymentSessionBodySchema } from "./schema";

import { WindcaveService } from "./service";
import { logger } from "firebase-functions";
import { WindcaveError } from "../utils/windcave.error";

const router = express.Router();

router.post(
  "/session",
  requirePost,
  requiredAuth,
  async (request: AuthenticatedRequest, response: Response) => {
    try {
      const validation = createPaymentSessionBodySchema.safeParse(request.body);
      let totalAmount = 0;
      if (!validation.success) {
        const errors = validation.error.issues
          .map((i) => `${i.path.join(".")}: ${i.message}`)
          .join(", ");
        return response.status(400).json({ success: false, errors });
      }
      totalAmount = await new WindcaveService().computeOrderTotal({
        items: validation.data.items,
      });

      logger.info("Total amount:", totalAmount);


      const paymentSessionUrl =
        await new WindcaveService().createPaymentSession({
          amount: totalAmount,
        });

      return response
        .status(200)
        .json({ success: true, data: { paymentSessionUrl } });
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
