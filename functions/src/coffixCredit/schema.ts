import { z } from "zod";

export const topupBodySchema = z.object({
  amount: z.number().positive(),
});

export type TopupBodySchema = z.infer<typeof topupBodySchema>;
