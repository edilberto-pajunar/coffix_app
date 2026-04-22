import express from "express";
import { requirePost } from "../middleware/method";
import { AuthenticatedRequest } from "../middleware/auth";
import { AddLogSchema } from "./schema";
import { addLog } from "./service";

const router = express.Router();

router.post(
  "/add",
  requirePost,
  async (request: AuthenticatedRequest, response) => {
    const validation = AddLogSchema.safeParse(request.body);
    if (!validation.success) {
      const errors = validation.error.issues
        .map((i) => `${i.path.join(".")}: ${i.message}`)
        .join(", ");
      return response.status(400).json({ success: false, errors });
    }

    try {
      const docId = await addLog(validation.data);
      return response.status(200).json({ success: true, docId });
    } catch (e: any) {
      return response.status(500).json({
        success: false,
        message: e.message ?? "Failed to add log",
      });
    }
  },
);

export default router;
