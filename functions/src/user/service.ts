import { firestore } from "../config/firebaseAdmin";

export async function verifyEmail({ userId }: { userId: string }) {
  const userRef = firestore.collection("customers").doc(userId);
  await userRef.set(
    {
      emailVerified: true,
    },
    { merge: true },
  );
}
