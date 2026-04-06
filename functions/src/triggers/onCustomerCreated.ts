import { ReferralService } from "../referrals/service";
import { logger } from "firebase-functions/v1";

export async function handleCustomerCreated(
  uid: string,
  data: FirebaseFirestore.DocumentData,
): Promise<void> {
  const email: string | undefined = data.email;
  if (!email) {
    logger.warn(
      `New customer ${uid} has no email — skipping referral activation`,
    );
    return;
  }
  try {
    const referralService = new ReferralService();
    await referralService.activateReferral(uid, email.toLowerCase());
  } catch (err) {
    logger.error(`Failed to activate referral for customer ${uid}:`, err);
  }
}
