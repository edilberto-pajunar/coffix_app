import express, { Request, Response } from "express";
import { requirePost } from "../middleware/method";
import { EmailService } from "./service";
import { sendGiftEmailSchema, sendInvoiceSchema } from "./schema";

const router = express.Router();
const emailService = new EmailService();

router.post("/gift", requirePost, async (req: Request, res: Response) => {
  const validation = sendGiftEmailSchema.safeParse(req.body);
  if (!validation.success) {
    const errors = validation.error.issues
      .map((i) => `${i.path.join(".")}: ${i.message}`)
      .join(", ");
    return res.status(400).json({ success: false, errors });
  }

  try {
    await emailService.sendGift(validation.data);
    return res.status(200).json({ success: true, message: "Gift email sent" });
  } catch (e: any) {
    return res.status(500).json({
      success: false,
      message: e.message ?? "Failed to send gift email",
    });
  }
});

export default router;
