import express, { Request } from "express";
import { requirePost } from "../middleware/method";
import { AuthenticatedRequest, requiredAuth } from "../middleware/auth";
import { NotificationSchema } from "./schema";
import { notificationService } from "./service";
import z from "zod";

const router = express.Router();

const BatchNotificationSchema = z.object({
  notifications: z.array(NotificationSchema).min(1),
});

router.post("/send", requirePost, async (request: Request, response) => {
  const validation = NotificationSchema.safeParse(request.body);
  if (!validation.success) {
    const errors = validation.error.issues
      .map((i) => `${i.path.join(".")}: ${i.message}`)
      .join(", ");
    return response.status(400).json({ success: false, errors });
  }

  const { customerId, title, message, metadata } = validation.data;

  try {
    await notificationService.sendNotification({
      customerId,
      title,
      message,
      metadata,
    });
    return response.status(200).json({ success: true });
  } catch (err) {
    return response
      .status(500)
      .json({ success: false, error: "Failed to send notification" });
  }
});

router.post(
  "/send-batch",
  requirePost,
  requiredAuth,
  async (request: AuthenticatedRequest, response) => {
    const validation = BatchNotificationSchema.safeParse(request.body);
    if (!validation.success) {
      const errors = validation.error.issues
        .map((i) => `${i.path.join(".")}: ${i.message}`)
        .join(", ");
      return response.status(400).json({ success: false, errors });
    }

    const { notifications } = validation.data;

    try {
      await notificationService.sendBatchNotifications(notifications);
      return response.status(200).json({ success: true });
    } catch (err) {
      return response
        .status(500)
        .json({ success: false, error: "Failed to send batch notifications" });
    }
  },
);

export default router;
