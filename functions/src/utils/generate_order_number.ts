import { firestore } from "../config/firebaseAdmin";

// Format: {storeId}{YYMMDD}{runningNumber} e.g. atdqdUXR8HQjRyBUJjEx260224001
export async function generateOrderNumber(storeId: string): Promise<string> {
  const now = new Date();
  const yy = now.getFullYear().toString().slice(-2);
  const mm = String(now.getMonth() + 1).padStart(2, "0");
  const dd = String(now.getDate()).padStart(2, "0");
  const dateKey = `${yy}${mm}${dd}`;

  return await firestore.runTransaction(async (tx) => {
    const counterRef = firestore
      .collection("stores")
      .doc(storeId)
      .collection("dailyCounters")
      .doc(dateKey);

    const counterSnap = await tx.get(counterRef);

    let nextNumber = 1;
    if (counterSnap.exists) {
      nextNumber = (counterSnap.data()?.lastRunningNumber ?? 0) + 1;
    }

    tx.set(counterRef, { lastRunningNumber: nextNumber }, { merge: true });

    const runningNumber = nextNumber.toString().padStart(3, "0");
    return `${storeId}${dateKey}${runningNumber}`;
  });
}
