import { printerFirestore } from "../config/firebaseAdmin";
import { createReceiptBodySchema, CreateReceiptBodySchema } from "./schema";
// import { nowNZ } from "../utils/nz_time";

export class ReceiptService {
  // create a print document to the printer database
  async createPrintQueue({
    receiptData,
  }: {
    receiptData: CreateReceiptBodySchema;
  }) {
    const validation = createReceiptBodySchema.safeParse(receiptData);
    if (!validation.success) {
      const errors = validation.error.issues
        .map((i) => `${i.path.join(".")}: ${i.message}`)
        .join(", ");
      throw new Error(errors);
    }
    const printQueueRef = printerFirestore.collection("printQueue").doc();

    // const now = nowNZ();
    const { duration } = validation.data;
    const printTime =
      duration > 0 ? new Date(Date.now() + duration * 60_000) : null;
    // const gst = validation.data.total * 0.15;
    const transactionNumber = validation.data.transactionNumber;
    await printQueueRef.set({
      printerId: validation.data.printerId,
      status: duration > 0 ? "scheduled" : "pending",
      printTime,
      label: transactionNumber,
      templateName: "ORDER",
      lines: [
        `Order #: ${transactionNumber}`, // Order #
        `${validation.data.customer}`, // Customer Name
        `${validation.data.orders}`, // Orders
        `Total: $${validation.data.total.toFixed(2)}`, // Total
        `Payment method: ${validation.data.paymentMethod}`, // Payment method
        `Order Time: ${validation.data.orderTime}`, // Order Time
        `Service Time: ${validation.data.serviceTime} | ${validation.data.storeName}`, // Service Time
      ],
    });
  }
}
