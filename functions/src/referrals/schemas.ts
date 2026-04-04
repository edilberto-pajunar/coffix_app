import { z } from "zod";

export const sendReferralSchema = z.object({
    emails: z.array(z.email()).min(1),
  });

export type SendReferralSchema = z.infer<typeof sendReferralSchema>;