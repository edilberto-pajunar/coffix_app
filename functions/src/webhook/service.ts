import FirebaseService from "../firebase/service";
import { WindcaveError } from "../utils/windcave.error";
import { WindcaveService } from "../windcave/service";
import { CoffixCreditService } from "../coffixCredit/service";
import { parseTopupMerchantReference } from "../coffixCredit/utils";

export class WebhookService {
  private readonly windcaveService: WindcaveService;
  private readonly firebaseService: FirebaseService;

  private readonly coffixCreditService: CoffixCreditService;

  constructor() {
    this.windcaveService = new WindcaveService();
    this.firebaseService = new FirebaseService();
    this.coffixCreditService = new CoffixCreditService();
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

    const merchantReference = transaction.merchantReference;
    if (!merchantReference) {
      throw new WindcaveError(400, {
        error: `No merchant reference for transaction: ${sessionId}`,
      });
    }

    const transactionDoc =
      await this.firebaseService.findTransactionBySessionId(sessionId);
    if (!transactionDoc) {
      throw new WindcaveError(400, {
        error: `No transaction found for session: ${sessionId}`,
      });
    }

    if (["approved", "declined", "cancelled"].includes(transactionDoc.status)) {
      return;
    }

    const authorised = transaction.authorised === true;
    const amount = Number(transaction.amount ?? 0) || transactionDoc.amount;

    const customerId = parseTopupMerchantReference(merchantReference);
    if (customerId) {
      if (authorised) {
        await this.coffixCreditService.addCredit(customerId, amount);
        await this.firebaseService.updateTransaction(transactionDoc.docId, {
          status: "approved",
          updatedAt: new Date(),
          paymentTime: new Date(),
          paymentMethod: transaction.method,
          sessionId,
          paymentId: transaction.id,
          responseText: transaction.responseText,
        });
      } else {
        await this.firebaseService.updateTransaction(transactionDoc.docId, {
          status: "declined",
          updatedAt: new Date(),
          method: transaction.method,
          sessionId,
          responseText: transaction.responseText,
        });
      }
      return;
    }

    const orderId = merchantReference;
    const orderDoc = await this.firebaseService.findOrderByOrderId(orderId);

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
        scheduledAt: new Date(
          Date.now() + (orderDoc?.duration ?? 0) * 60_000,
        ),
      });
    } else {
      await this.firebaseService.updateTransaction(transactionDoc.docId, {
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
