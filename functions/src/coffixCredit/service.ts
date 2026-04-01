import { firestore } from "../config/firebaseAdmin";
import { logger } from "firebase-functions";
import { GLOBAL_COLLECTION_ID, RESEND_FROM_EMAIL } from "../constant/constant";
import FirebaseService from "../firebase/service";
import { InsufficientCreditError, MinCreditError } from "./errors";

export { InsufficientCreditError, MinCreditError };

export class CoffixCreditService {
  async getCreditAvailable(customerId: string): Promise<number> {
    const snap = await firestore.collection("customers").doc(customerId).get();
    if (!snap.exists) return 0;
    return (snap.data()?.creditAvailable ?? 0) as number;
  }

  async deductCredit(customerId: string, amount: number): Promise<void> {
    const customerRef = firestore.collection("customers").doc(customerId);

    await firestore.runTransaction(async (tx) => {
      const customerSnap = await tx.get(customerRef);
      if (!customerSnap.exists) {
        throw new Error("Customer not found");
      }

      const data = customerSnap.data();
      const creditAvailable = (data?.creditAvailable ?? 0) as number;

      if (creditAvailable < amount) {
        throw new InsufficientCreditError(creditAvailable, amount);
      }

      tx.update(customerRef, {
        creditAvailable: creditAvailable - amount,
      });
    });
  }

  async addCredit(customerId: string, amount: number): Promise<void> {
    const customerRef = firestore.collection("customers").doc(customerId);
    const globals = await firestore
      .collection("global")
      .doc("EQ0i4V6H47Ra7yMCdG7B")
      .get();
    if (!globals.exists) {
      throw new Error("Global not found");
    }
    const globalData = globals.data();
    if (!globalData) {
      throw new Error("Global data not found");
    }

    const minTopUp = (globalData.minTopUp ?? 0) as number;
    const basicDiscount = ((globalData.basicDiscount ?? 0) / 100) as number;
    const discountLevel2 = ((globalData.discountLevel2 ?? 0) / 100) as number;
    const discountLevel3 = ((globalData.discountLevel3 ?? 0) / 100) as number;
    const topupLevel2 = (globalData.topupLevel2 ?? Infinity) as number;
    const topupLevel3 = (globalData.topupLevel3 ?? Infinity) as number;

    if (amount < minTopUp) {
      throw new Error(`Top-up amount is below the minimum of ${minTopUp}`);
    }

    let bonus: number;
    if (amount < topupLevel2) {
      bonus = amount * basicDiscount;
    } else if (amount < topupLevel3) {
      bonus = amount * discountLevel2;
    } else {
      bonus = amount * discountLevel3;
    }
    const totalAmount = amount + bonus;

    await firestore.runTransaction(async (tx) => {
      const customerSnap = await tx.get(customerRef);
      const current = customerSnap.exists
        ? ((customerSnap.data()?.creditAvailable ?? 0) as number)
        : 0;

      tx.set(
        customerRef,
        { creditAvailable: current + totalAmount },
        { merge: true },
      );
    });
  }

  async shareCredit({
    senderId,
    senderFirstName,
    senderLastName,
    recipientFirstName,
    recipientEmail,
    amount,
  }: {
    senderId: string;
    senderFirstName: string;
    senderLastName: string;
    recipientFirstName: string;
    recipientEmail: string;
    amount: number;
  }): Promise<void> {
    const firebaseService = new FirebaseService();

    // 1. Load global config for minCreditToShare
    const globals = await firestore
      .collection("global")
      .doc(GLOBAL_COLLECTION_ID)
      .get();
    const minCreditToShare = (globals.data()?.minCreditToShare ?? 0) as number;

    // 2. Validate minimum amount
    if (amount < minCreditToShare) {
      throw new MinCreditError(minCreditToShare);
    }

    // 3. Validate sender exists and has sufficient credit
    const senderRef = firestore.collection("customers").doc(senderId);
    const senderSnap = await senderRef.get();
    if (!senderSnap.exists) {
      throw new Error("Sender not found");
    }
    const creditAvailable = (senderSnap.data()?.creditAvailable ?? 0) as number;
    if (creditAvailable < amount) {
      throw new InsufficientCreditError(creditAvailable, amount);
    }

    // 4. Look up recipient by email
    const recipient = await firebaseService.findCustomerByEmail(recipientEmail);

    if (recipient) {
      // Branch A: recipient exists — transfer atomically
      const recipientRef = firestore
        .collection("customers")
        .doc(recipient.customerId);
      await firestore.runTransaction(async (tx) => {
        const [senderSnap2, recipientSnap] = await Promise.all([
          tx.get(senderRef),
          tx.get(recipientRef),
        ]);
        const senderCredit = (senderSnap2.data()?.creditAvailable ??
          0) as number;
        if (senderCredit < amount) {
          throw new InsufficientCreditError(senderCredit, amount);
        }
        const recipientCredit = (recipientSnap.data()?.creditAvailable ??
          0) as number;
        tx.update(senderRef, { creditAvailable: senderCredit - amount });
        tx.set(
          recipientRef,
          { creditAvailable: recipientCredit + amount },
          { merge: true },
        );
        firebaseService.createGiftTransaction(tx, {
          senderId,
          senderFirstName,
          senderLastName,
          recipientEmail,
          recipientCustomerId: recipient.customerId,
          amount,
        });
      });
    } else {
      // Branch B: recipient does not exist — deduct and record pending gift
      await firestore.runTransaction(async (tx) => {
        const senderSnap2 = await tx.get(senderRef);
        const senderCredit = (senderSnap2.data()?.creditAvailable ??
          0) as number;
        if (senderCredit < amount) {
          throw new InsufficientCreditError(senderCredit, amount);
        }
        tx.update(senderRef, { creditAvailable: senderCredit - amount });
        firebaseService.createGiftTransaction(tx, {
          senderId,
          senderFirstName,
          senderLastName,
          recipientEmail,
          amount,
        });
      });
    }

    // 5. Send gift notification email (non-fatal)
    try {
      const RESEND_API_KEY = process.env.RESEND_API_KEY;
      if (!RESEND_API_KEY) {
        logger.warn(
          "RESEND_API_KEY not set – skipping gift notification email",
        );
        return;
      }

      const templateSnap = await firestore
        .collection("emails")
        .doc("GIFT_NOTIFICATION")
        .get();
      const templateData = templateSnap.data();
      if (!templateData) {
        logger.warn("Gift notification email template not found");
        return;
      }

      const senderName = `${senderFirstName} ${senderLastName}`.trim();
      const subject: string =
        (templateData.subject as string) ?? "You received a gift!";
      const body: string = ((templateData.body as string) ?? "")
        .replace(/\{\{senderName\}\}/g, senderName)
        .replace(/\{\{amount\}\}/g, amount.toFixed(2))
        .replace(/\{\{recipientFirstName\}\}/g, recipientFirstName);

      const resendRes = await fetch("https://api.resend.com/emails", {
        method: "POST",
        headers: {
          Authorization: `Bearer ${RESEND_API_KEY}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          from: RESEND_FROM_EMAIL,
          to: [recipientEmail],
          subject,
          html: body,
        }),
      });

      if (!resendRes.ok) {
        const err = await resendRes.json();
        logger.error("Failed to send gift notification email", err);
      }
    } catch (emailError) {
      logger.error("Error sending gift notification email", emailError);
    }
  }
}
