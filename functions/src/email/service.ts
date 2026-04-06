import { firestore } from "../config/firebaseAdmin";
import { RESEND_FROM_EMAIL } from "../constant/constant";
import { renderTemplate } from "../utils/renderEmailTemplate";
import { wrapInEmailShell } from "../utils/emailShell";
import { orderEmailTemplate } from "../utils/templates/order_email_template";
import { logger } from "firebase-functions";

export interface GiftEmailParams {
  to: string;
  senderFirstName: string;
  senderLastName: string;
  amount: number;
  recipientFirstName?: string;
}

export interface OrderReceiptEmailParams {
  to: string;
  orderNumber: string;
  storeName: string;
  storeAddress: string;
  createdAt: string;
  paymentMethod: string;
  total: number;
  items: Array<{
    name: string;
    quantity: number;
    price: number;
    modifiers?: string[];
  }>;
}

function formatCurrency(amount: number): string {
  return `$${amount.toFixed(2)}`;
}

function buildItemRows(items: OrderReceiptEmailParams["items"]): string {
  if (!items.length) {
    return `<tr><td colspan="4" style="padding:12px 0;color:#888;font-size:14px;">No items</td></tr>`;
  }

  return items
    .map((item) => {
      const subtotal = item.quantity * item.price;
      const modifierHtml = item.modifiers?.length
        ? `<div class="item-modifiers">${item.modifiers.join(", ")}</div>`
        : "";
      return `
        <tr>
          <td>
            <div class="item-name">${item.name}</div>
            ${modifierHtml}
          </td>
          <td class="right">${item.quantity}</td>
          <td class="right">${formatCurrency(item.price)}</td>
          <td class="right">${formatCurrency(subtotal)}</td>
        </tr>`;
    })
    .join("");
}

export class EmailService {
  private async resendSend({
    to,
    subject,
    html,
  }: {
    to: string;
    subject: string;
    html: string;
  }): Promise<void> {
    const RESEND_API_KEY = process.env.RESEND_API_KEY;
    if (!RESEND_API_KEY) throw new Error("RESEND_API_KEY not configured");

    const res = await fetch("https://api.resend.com/emails", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${RESEND_API_KEY}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        from: RESEND_FROM_EMAIL,
        to: [to],
        subject,
        html,
      }),
    });

    if (!res.ok) {
      const err = await res.json();
      logger.error("Resend API error", {
        resendStatus: res.status,
        resendError: err,
      });
      throw new Error(`Resend ${res.status}: ${JSON.stringify(err)}`);
    }
  }

  async sendGift(params: GiftEmailParams): Promise<void> {
    const templateSnap = await firestore.collection("emails").doc("GIFT").get();
    const templateData = templateSnap.data();
    if (!templateData)
      throw new Error("GIFT_NOTIFICATION template not found in Firestore");

    const senderName =
      `${params.senderFirstName} ${params.senderLastName}`.trim();
    const subject = renderTemplate(
      (templateData.subject as string) ??
        "You received a Coffix gift from {{ SENDER_FULLNAME }}!",
      { SENDER_FULLNAME: senderName },
    );
    const html = wrapInEmailShell(
      renderTemplate(templateData.content as string, {
        SENDER_FULLNAME: senderName,
        RECIPIENT_FIRST_NAME: params.recipientFirstName ?? "",
        AMOUNT: params.amount.toFixed(2),
        DATE: new Date().toLocaleDateString("en-NZ"),
      }),
    );

    await this.resendSend({ to: params.to, subject, html });
  }

  async sendOrderReceipt(params: OrderReceiptEmailParams): Promise<void> {
    const shortNumber = params.orderNumber.slice(-6);
    const html = orderEmailTemplate
      .replace(/{{orderNumber}}/g, shortNumber)
      .replace(/{{storeName}}/g, params.storeName)
      .replace(/{{storeAddress}}/g, params.storeAddress)
      .replace(/{{createdAt}}/g, params.createdAt)
      .replace(/{{total}}/g, formatCurrency(params.total))
      .replace(/{{paymentMethod}}/g, params.paymentMethod)
      .replace(/{{items}}/g, buildItemRows(params.items));

    await this.resendSend({
      to: params.to,
      subject: `Your Coffix Order Receipt #${params.orderNumber}`,
      html,
    });
  }
}
