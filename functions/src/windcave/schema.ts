import { z } from "zod";

export const createPaymentSessionBodySchema = z.object({
  storeId: z.string().trim(),
  items: z.array(
    z.object({
      productId: z.string().trim(),
      quantity: z.number().positive(),
      selectedModifiers: z.object({}),
    }),
  ),
});

const linkSchema = z.object({
  href: z.string(),
  rel: z.string(),
  method: z.string(),
});

export const windcaveSessionSchema = z.object({
  id: z.string(),
  state: z.string(),
  links: z.array(linkSchema),
});

export type WindcaveSessionResponse = z.infer<typeof windcaveSessionSchema>;
