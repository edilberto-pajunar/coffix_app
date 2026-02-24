import FirebaseService from "../firebase/service";
import { WindcaveError } from "../utils/windcave.error";
import { WindcaveService } from "../windcave/service";

export class WebhookService {
  private readonly windcaveService: WindcaveService;
  private readonly firebaseService: FirebaseService;

  constructor() {
    this.windcaveService = new WindcaveService();
    this.firebaseService = new FirebaseService();
  }

  /**
   * This will verify if the webhook is valid and then update the order in the database
   * @param sessionId - The session ID to handle the webhook for
   */
  async handleWebhook(sessionId: string) {
    // 1) Query windcave session
    const windcaveSession = await this.windcaveService.getSession(sessionId);
    const transactions = windcaveSession.transactions;
    if (transactions.length === 0) {
      throw new WindcaveError(400, {
        error: `No transactions found for session: ${sessionId}`,
      });
    }

    // Pick the latest transaction
    const transaction = transactions[0];

    const orderId = transaction.merchantReference;
    if (!orderId) {
      throw new WindcaveError(400, {
        error: `No order ID found for transaction: ${sessionId}`,
      });
    }

    const transactionDoc =
      await this.firebaseService.findTransactionBySessionId(sessionId);
    if (!transactionDoc) {
      throw new WindcaveError(400, {
        error: `No transaction found for session: ${sessionId}`,
      });
    }

    // 3 Idempotency guard
    if (["approved", "declined", "cancelled"].includes(transactionDoc.status)) {
      return;
    }

    const authorised = transaction.authorised === true;
    if (authorised) {
      await this.firebaseService.updateTransaction(transactionDoc.docId, {
        status: "approved",
        updatedAt: new Date(),
        paymentTime: new Date(),
        paymentMethod: transaction.method,
        sessionId,
        paymentId: transaction.id,
        responseText: transaction.responseText,
      });

      await this.firebaseService.updateOrder(orderId, {
        status: "paid",
        paidAt: new Date(),
      });
    } else {
      // Determine decline vs cancelled if you can
      await this.firebaseService.updateTransaction(transactionDoc.id, {
        status: "declined",
        updatedAt: new Date(),
        method: transaction.method,
        sessionId,
        responseText: transaction.responseText,
      });

      await this.firebaseService.updateOrder(orderId, {
        status: "payment_failed",
        failedAt: new Date(),
      });
    }
  }
}
