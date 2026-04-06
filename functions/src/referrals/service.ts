import { getAuth } from "firebase-admin/auth";
import { firestore } from "../config/firebaseAdmin";
import { RESEND_FROM_EMAIL } from "../constant/constant";
import { renderTemplate } from "../utils/renderEmailTemplate";
import { wrapInEmailShell } from "../utils/emailShell";
import { logger } from "firebase-functions/v1";
import { generateCouponCode } from "../utils/generateCouponCode";

export class ReferralService {
  async createReferral({
    referrerUid,
    referee,
  }: {
    referrerUid: string;
    referee: { email: string; name: string };
  }): Promise<void> {
    const referralRef = firestore.collection("referrals").doc();
    await referralRef.set({
      docId: referralRef.id,
      referralTime: new Date(),
      referrer: referrerUid,
      referee: referee.email,
      refereeUid: null,
      signupTime: null,
      expiresAt: null,
      couponId: null,
      refereeCouponId: null,
      status: "pending",
    });
  }

  async activateReferral(refereeUid: string, email: string): Promise<void> {
    const snap = await firestore
      .collection("referrals")
      .where("referee", "==", email.toLowerCase())
      .where("status", "==", "pending")
      .limit(1)
      .get();

    if (snap.empty) return;

    const referralDoc = snap.docs[0];
    const signupTime = new Date();
    const expiresAt = new Date(signupTime.getTime() + 7 * 24 * 60 * 60 * 1000);

    await referralDoc.ref.update({
      refereeUid,
      signupTime,
      expiresAt,
      status: "active",
    });

    logger.info(`Referral activated for referee: ${refereeUid}`);
  }

  async handleFirstPurchase({
    customerId,
    orderId,
    paidAt,
  }: {
    customerId: string;
    orderId: string;
    paidAt: Date;
  }): Promise<void> {
    // 1. Find active referral for this referee
    const referralSnap = await firestore
      .collection("referrals")
      .where("refereeUid", "==", customerId)
      .where("status", "==", "active")
      .limit(1)
      .get();

    if (referralSnap.empty) return;

    const referralDoc = referralSnap.docs[0];
    const referral = referralDoc.data();

    // 2. Check expiry window
    const expiresAt: Date =
      referral.expiresAt?.toDate?.() ?? referral.expiresAt;

    if (paidAt > expiresAt) {
      await referralDoc.ref.update({ status: "expired" });
      logger.info(`Referral expired for referee: ${customerId}`);
      return;
    }

    // 3. Ensure this is the first paid order
    const paidOrdersSnap = await firestore
      .collection("orders")
      .where("customerId", "==", customerId)
      .where("status", "==", "paid")
      .limit(2)
      .get();

    if (paidOrdersSnap.size > 1) return;

    // 4. Generate unique coupon codes
    const referrerCode = await this.generateUniqueCode();
    const refereeCode = await this.generateUniqueCode();

    const now = new Date();
    const couponExpiry = new Date(now.getTime() + 30 * 24 * 60 * 60 * 1000);

    const referrerCouponRef = firestore.collection("coupons").doc();
    const refereeCouponRef = firestore.collection("coupons").doc();

    const baseCoupon = {
      type: "fixed",
      amount: 5,
      usageLimit: 1,
      usageCount: 0,
      source: "referral",
      referralId: referralDoc.id,
      isUsed: false,
      expiryDate: couponExpiry,
      storeId: null,
      notes: "Referral reward - $5 off your next order",
    };

    // 5. Batch write both coupons + update referral atomically
    const batch = firestore.batch();

    batch.set(referrerCouponRef, {
      ...baseCoupon,
      docId: referrerCouponRef.id,
      code: referrerCode,
      userIds: [referral.referrer],
    });

    batch.set(refereeCouponRef, {
      ...baseCoupon,
      docId: refereeCouponRef.id,
      code: refereeCode,
      userIds: [customerId],
    });

    batch.update(referralDoc.ref, {
      status: "rewarded",
      couponId: referrerCouponRef.id,
      refereeCouponId: refereeCouponRef.id,
    });

    await batch.commit();

    logger.info(
      `Referral rewarded. Referrer: ${referral.referrer}, Referee: ${customerId}, Order: ${orderId}`,
    );
  }

  private async generateUniqueCode(): Promise<string> {
    for (let attempt = 0; attempt < 5; attempt++) {
      const code = generateCouponCode();
      const existing = await firestore
        .collection("coupons")
        .where("code", "==", code)
        .limit(1)
        .get();
      if (existing.empty) return code;
    }
    throw new Error("Failed to generate a unique coupon code after 5 attempts");
  }

  async sendReferralEmail({
    referrerUid,
    referee,
  }: {
    referrerUid: string;
    referee: { email: string; name: string };
  }): Promise<void> {
    const RESEND_API_KEY = process.env.RESEND_API_KEY;
    if (!RESEND_API_KEY) {
      logger.warn("RESEND_API_KEY not set – skipping referral email");
      return;
    }

    const [referrerRecord, templateSnap] = await Promise.all([
      getAuth().getUser(referrerUid),
      firestore.collection("emails").doc("REFERRAL").get(),
    ]);

    const templateData = templateSnap.data();
    if (!templateData) {
      logger.warn("Referral email template not found in emails/REFERRAL");
      return;
    }

    const referrerName = referrerRecord.displayName ?? "";
    const referrerEmail = referrerRecord.email ?? "";
    const appDownloadUrl = process.env.APP_DOWNLOAD_URL ?? "";

    const subject: string =
      (templateData.subject as string) ?? "You've been invited to Coffix!";

    const renderedContent = renderTemplate(
      (templateData.content as string) ?? "",
      {
        REFEREE_NAME: referee.name,
        REFEREE_EMAIL: referee.email,
        REFERRER_NAME: referrerName,
        REFERRER_EMAIL: referrerEmail,
        APP_DOWNLOAD_URL: appDownloadUrl,
        firstName: referee.name,
        email: referee.email,
        appUrl: appDownloadUrl,
        currentYear: new Date().getFullYear(),
      },
    );

    const html = wrapInEmailShell(renderedContent);

    const resendRes = await fetch("https://api.resend.com/emails", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${RESEND_API_KEY}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        from: RESEND_FROM_EMAIL,
        to: [referee.email],
        subject,
        html,
      }),
    });

    if (!resendRes.ok) {
      const err = await resendRes.json();
      logger.error("Failed to send referral email", {
        email: referee.email,
        err,
      });
    }
  }
}
