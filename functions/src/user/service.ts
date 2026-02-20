import { firestore } from "../config/firebaseAdmin";

export async function verifyEmail({ userId }: { userId: string }) {
  const userRef = firestore.collection("users").doc(userId);
  await userRef.set(
    {
      emailVerified: true,
    },
    { merge: true },
  );
}
