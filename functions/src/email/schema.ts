import { z } from "zod";

export const sendGiftEmailSchema = z.object({
  to: z.email(),
  senderFirstName: z.string().min(1),
  senderLastName: z.string().min(1),
  amount: z.number().positive(),
  recipientFirstName: z.string().optional(),
});

export const orderItemSchema = z.object({
  name: z.string().min(1),
  quantity: z.number().int().positive(),
  price: z.number().nonnegative(),
  modifiers: z.array(z.string()).optional(),
});

export const sendOrderReceiptEmailSchema = z.object({
  to: z.email(),
  orderNumber: z.string().min(1),
  storeName: z.string().min(1),
  storeAddress: z.string().min(1),
  createdAt: z.string().min(1),
  paymentMethod: z.string().min(1),
  total: z.number().nonnegative(),
  items: z.array(orderItemSchema).min(1),
});

export interface SendEmailParams {
  email: string;
  subject: string;
  documentId: string;
  variables: Record<string, string | number>;
}

export interface GiftEmailParams {
  to: string;
  senderFirstName: string;
  senderLastName: string;
  amount: number;
  recipientFirstName?: string;
  recipientLastName?: string;
  transactionNumber?: string;
}

export type SendGiftEmailSchema = z.infer<typeof sendGiftEmailSchema>;
export type SendOrderReceiptEmailSchema = z.infer<
  typeof sendOrderReceiptEmailSchema
>;
