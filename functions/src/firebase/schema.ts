import { z } from "zod";

export const createTokenBodySchema = z
  .object({
    email: z.string().trim().email(),
    password: z.string().min(6),
  })
  .strict();
