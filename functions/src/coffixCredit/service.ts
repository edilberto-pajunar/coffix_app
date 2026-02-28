import { firestore } from "../config/firebaseAdmin";

export class InsufficientCreditError extends Error {
  constructor(
    public creditAvailable: number,
    public required: number,
  ) {
    super(
      `Insufficient credit. Available: ${creditAvailable}, required: ${required}`,
    );
  }
}

export class CoffixCreditService {
  async getCreditAvailable(customerId: string): Promise<number> {
    const snap = await firestore
      .collection("customers")
      .doc(customerId)
      .get();
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

    await firestore.runTransaction(async (tx) => {
      const customerSnap = await tx.get(customerRef);
      const current = customerSnap.exists
        ? ((customerSnap.data()?.creditAvailable ?? 0) as number)
        : 0;

      tx.set(customerRef, { creditAvailable: current + amount }, { merge: true });
    });
  }
}
