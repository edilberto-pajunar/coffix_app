# Coffee on Us — Referral Feature

## Overview

Tapping **"Coffee on Us"** navigates to page [21] where the customer can send a referral email to friends and earn a free coffee.

- Email content is pulled from the **Email** table in Firestore.
- The referral email is sent **only** to recipients who are not yet in the database.

## Firestore — `referrals` Collection

**Path:** `referrals/{docId}`


| Field          | Type        | Description                                 |
| -------------- | ----------- | ------------------------------------------- |
| `docId`        | `String`    | Unique identifier for the referral          |
| `referralTime` | `Timestamp` | When the referral was created               |
| `referrer`     | `String`    | Customer ID of the referring customer       |
| `referee`      | `String`    | Email address of the potential new customer |


## Flow

1. Customer taps **"Coffee on Us"** → navigates to page [21].
2. Customer enters friend's email address.
3. App checks if the email already exists in the DB.
  - If **exists** → referral is not sent.
  - If **not found** → referral document is created under `referrals/{docId}` and the email is dispatched using the template from the **Email** table.
4. The referral document is created, but the free coffee reward is **not yet granted**.
5. The reward is only triggered for the referrer **once the referee completes their first coffee purchase**.

## Edge Case — Self-Referral via a Different Email

A customer could refer themselves using a secondary email address, exploiting the reward.

**Example:**
- `pajunar0@gmail.com` refers `espajunarjr@gmail.com`
- Both emails belong to the same person in real life

### Prevention Strategies

Since the referee has not signed up yet at referral time, the check must happen **at or after referee signup**:

Since authentication is **email + OTP only** (no phone number collected), prevention relies on:

1. **Email self-referral guard (client + server)**
   - Before sending the referral, check that the entered referee email is not equal to any email associated with the referrer's account.
   - This is the only identity signal we have at referral time.

2. **Device ID / fingerprint check (recommended)**
   - Capture a device identifier at signup (e.g. via `device_info_plus`).
   - Store it on the user document in Firestore.
   - At reward time, a Cloud Function checks: `referee.deviceId !== referrer.deviceId`.
   - If they match → set `referral.status = "invalid"` and skip the reward.

3. **Referral validation step before reward**
   - Before granting the free coffee, a Cloud Function validates:
     - `referee.email !== referrer.email`
     - `referee.deviceId !== referrer.deviceId` *(if collected)*
     - `referee.uid !== referrer.uid`
   - If any check fails → set `referral.status = "invalid"` and skip the reward.

> **Note:** Without phone verification, device ID is the strongest signal we have to detect same-person fraud across different emails. There is no foolproof solution — a user on a different device will still be hard to detect.

### Suggested `referrals` Status Field

Add a `status` field to the referral document to track state:

| Value | Meaning |
|---|---|
| `pending` | Referee has not signed up yet |
| `active` | Referee signed up and passed validation |
| `rewarded` | Referee made first purchase; reward granted to referrer |
| `invalid` | Self-referral or fraud detected; reward blocked |

