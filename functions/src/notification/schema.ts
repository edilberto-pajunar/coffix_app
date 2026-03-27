import z from "zod";

export const NotificationSchema = z.object({
  customerId: z.string(),
  title: z.string(),
  message: z.string(),
  metadata: z.record(z.string(), z.any()).optional(),
});

export type NotificationSchema = z.infer<typeof NotificationSchema>;
