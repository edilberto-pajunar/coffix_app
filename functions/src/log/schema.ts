import { z } from "zod";

export const LogSeverityLevel = z.enum(["error", "warning", "info", "success"]);
export const LogCategory = z.enum([
  "auth",
  "store",
  "product",
  "refund",
  "purchase",
  "referral",
  "info",
  "profile",
  "gift",
  "email",
  "webhook",
]);

export const AddLogSchema = z.object({
  // where the user navigates on the app
  page: z.string().optional(),
  // if the log is under customers collection
  customerId: z.string().optional(),
  // if the log is under staffs collection
  userId: z.string().optional(),
  category: LogCategory,
  severityLevel: LogSeverityLevel,
  // what the user did
  action: z.string().optional(),
  // additional notes
  notes: z.string().optional(),
});
