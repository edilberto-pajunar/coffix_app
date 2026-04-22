import { getAuth } from "firebase-admin/auth";
import { firestore } from "../config/firebaseAdmin";
import { logger } from "firebase-functions/v1";
import { addLog } from "../log/service";

export class AuthService {
  async customerHasAccount({ email }: { email: string }) {
    try {
      // verify if the user is already registered
      const user = await getAuth().getUserByEmail(email);
      addLog({
        customerId: user.uid,
        category: "auth",
        severityLevel: "info",
        action: "Check if customer has account",
        notes: `Customer ${email} ${!!user ? "has" : "does not have"} account`,
      });

      return !!user;
    } catch (error: any) {
      if (error.code === "auth/user-not-found") {
        addLog({
          category: "auth",
          severityLevel: "error",
          action: "Check if customer has account",
          notes: `Customer ${email} does not have account`,
        });
        return false;
      }
      throw error;
    }
  }

  async blackListCustomer({ email }: { email: string }) {
    const blacklistedEmails = await firestore
      .collection("blacklistedEmails")
      .get();

    logger.info(`Checking if email ${email} is blacklisted`, {
      email,
      blacklistedEmails: blacklistedEmails.docs.map((doc) => doc.data().email),
    });
    return blacklistedEmails.docs.some((doc) => doc.data().email === email);
  }
}
