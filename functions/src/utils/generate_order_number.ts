import { firestore } from "../config/firebaseAdmin";

// Format: {storeId}{runningNumber} e.g. {storeId}{000001}
export async function generateOrderNumber(storeId: string): Promise<string> {
  return await firestore.runTransaction(async (tx) => {
    const counterRef = firestore
      .collection("stores")
      .doc(storeId)
      .collection("counters")
      .doc("orders"); // single doc for all time

    const counterSnap = await tx.get(counterRef);

    let nextNumber = 1;
    if (counterSnap.exists) {
      nextNumber = (counterSnap.data()?.lastRunningNumber ?? 0) + 1;
    }

    tx.set(counterRef, { lastRunningNumber: nextNumber }, { merge: true });

    const runningNumber = nextNumber.toString().padStart(6, "0");
    return `${storeId}${runningNumber}`;
  });
}

// generate transaction number
export async function generateTransactionNumber(): Promise<string> {
  return await firestore.runTransaction(async (tx) => {
    const counterRef = firestore
      .collection("global")
      .doc("EQ0i4V6H47Ra7yMCdG7B");

    const counterSnap = await tx.get(counterRef);

    let nextNumber = 1;
    if (counterSnap.exists) {
      nextNumber = (Number(counterSnap.data()?.invoiceCounter) || 0) + 1;
    }

    tx.set(counterRef, { invoiceCounter: nextNumber }, { merge: true });

    const digits = nextNumber.toString().length;
    return nextNumber.toString().padStart(Math.max(6, digits), "0");
  });
}
