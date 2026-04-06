# Coffee on Us — Referral Feature

## Overview

Tapping **"Coffee on Us"** navigates to page [21] where the customer can send a referral email to friends and earn a free coffee.

- Email content is pulled from the **Email** table in Firestore.
- The referral email is sent **only** to recipients who are not yet in the database.

## Firestore — `referrals` Collection

**Path:** `referrals/{docId}`


| Field             | Type        | Description                                                      |
| ----------------- | ----------- | ---------------------------------------------------------------- |
| `docId`           | `String`    | Unique identifier for the referral                               |
| `referralTime`    | `Timestamp` | When the referral was created                                    |
| `referrer`        | `String`    | Customer ID of the referring customer                            |
| `referee`         | `String`    | Email address of the potential new customer                      |
| `refereeUid`      | `String`    | UID of the referee once they sign up (null until then)           |
| `signupTime`      | `Timestamp` | When the referee signed up (null until then)                     |
| `expiresAt`       | `Timestamp` | 7 days after `signupTime` — deadline for first purchase          |
| `status`          | `String`    | See status table below                                           |
| `couponId`        | `String`    | ID of the $5 coupon created for the referrer (null until rewarded) |
| `refereeCouponId` | `String`    | ID of the $5 coupon created for the referee (null until rewarded)  |


## 7-Day Purchase Window

The referrer earns the free coffee **only if the referee makes their first purchase within 7 days of signing up**.

- The `expiresAt` timestamp is set to `signupTime + 7 days` when the referee creates their account.
- A Cloud Function triggered on order completion checks whether `order.createdAt <= referral.expiresAt`.
- If the window has passed → set `referral.status = "expired"` and skip the reward.
- If within the window → grant the reward and create a `$5` coupon for **both** the referrer and the referee.

## Coupon Types

There are two distinct coupon types in the system, both stored in the `coupons` collection but with different targeting and consumption rules.

---

### Type A — Referral Coupon (single-user, auto-generated)

Created by a Cloud Function when the referee purchases within 7 days.

**Path:** `coupons/{couponId}`

| Field        | Type        | Value                                      |
| ------------ | ----------- | ------------------------------------------ |
| `code`       | `String`    | Auto-generated unique code                 |
| `type`       | `String`    | `"fixed"`                                  |
| `amount`     | `Number`    | `5` (USD)                                  |
| `userIds`    | `String[]`  | `[referrerUid]` — single targeted user     |
| `usageLimit` | `Number`    | `1`                                        |
| `usageCount` | `Number`    | `0` (incremented on redemption)            |
| `source`     | `String`    | `"referral"`                               |
| `referralId` | `String`    | ID of the triggering referral document     |
| `isUsed`     | `Boolean`   | `false`                                    |
| `storeId`    | `String`    | Optional — restrict to a specific store    |
| `notes`      | `String`    | Optional internal notes                    |
| `createdAt`  | `Timestamp` | Time the coupon was issued                 |
| `expiryDate` | `Timestamp` | Coupon validity (e.g. 30 days from issue)  |

The `couponId` is written back to `referrals/{docId}.couponId` and `referral.status` is set to `"rewarded"`.

---

### Type B — Admin Coupon (multi-user, manually released)

Created by an admin targeting multiple users or all users.

**Path:** `coupons/{couponId}`

| Field        | Type        | Value                                                                  |
| ------------ | ----------- | ---------------------------------------------------------------------- |
| `code`       | `String`    | Admin-defined promo code (e.g. `WELCOME10`)                           |
| `type`       | `String`    | `"fixed"` or `"percent"`                                              |
| `amount`     | `Number`    | Discount value (fixed $ or percentage)                                |
| `userIds`    | `String[]`  | List of targeted UIDs — **empty/null means any user can redeem**      |
| `usageLimit` | `Number`    | Max total redemptions across all users (e.g. `500`)                   |
| `usageCount` | `Number`    | Running total of redemptions — incremented atomically per redemption  |
| `source`     | `String`    | `"admin"`                                                             |
| `isUsed`     | `Boolean`   | Not used for multi-user coupons — rely on `usageCount` instead        |
| `storeId`    | `String`    | Optional — restrict to a specific store                               |
| `notes`      | `String`    | Optional admin notes / campaign label                                 |
| `createdAt`  | `Timestamp` | When the coupon was created                                           |
| `expiryDate` | `Timestamp` | When the coupon expires                                               |

#### Validation at Purchase Time (Admin Coupon)

When a user applies a coupon code at checkout, a Cloud Function validates in order:

1. **Code exists** — query `coupons` where `code == enteredCode`.
2. **Not expired** — `expiryDate >= now`.
3. **User is eligible** — `userIds` is empty/null **OR** `userIds` contains the current user's UID.
4. **Usage limit not reached** — `usageCount < usageLimit`.
5. **No duplicate use** — check `couponRedemptions/{couponId}_{userId}` does not exist.

If all checks pass:
- Apply the discount to the order.
- Atomically increment `usageCount` (Firestore transaction).
- Write a `couponRedemptions/{couponId}_{userId}` record.

#### Per-User Redemption Tracking

**Path:** `couponRedemptions/{couponId}_{userId}`

| Field        | Type        | Description                        |
| ------------ | ----------- | ---------------------------------- |
| `couponId`   | `String`    | Reference to the coupon            |
| `userId`     | `String`    | UID of the user who redeemed       |
| `orderId`    | `String`    | Order where the coupon was applied |
| `redeemedAt` | `Timestamp` | When the redemption occurred       |

> This prevents a single user from redeeming the same admin coupon more than once, regardless of `usageLimit`.

## Flow

1. Customer taps **"Coffee on Us"** → navigates to page [21].
2. Customer enters friend's email address.
3. App checks if the email already exists in the DB.
  - If **exists** → referral is not sent.
  - If **not found** → referral document is created under `referrals/{docId}` and the email is dispatched using the template from the **Email** table.
4. Referral document is created with `status = "pending"`.
5. Referee signs up → Cloud Function sets `refereeUid`, `signupTime`, `expiresAt = signupTime + 7 days`, and `status = "active"`.
6. Referee makes their **first purchase within 7 days** → Cloud Function:
   a. Validates the referral (see Edge Case section).
   b. Checks `order.paidAt <= referral.expiresAt`.
   c. Creates a `$5` coupon in the `coupons` collection for the **referrer** (`couponId`) and a second `$5` coupon for the **referee** (`refereeCouponId`). Both coupons expire 30 days from issuance.
   d. Writes `couponId` and `refereeCouponId` back to the referral document.
   e. Sets `referral.status = "rewarded"`.
7. If the 7-day window passes without a purchase → set `referral.status = "expired"` (via scheduled function or lazy check at purchase time).

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

## Email Template

### Template Name (for Firestore Email table)

```
referral_invite
```

### Subject

```
{{referrerName}} is buying you a coffee ☕
```

### Body (HTML)

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Coffee on Us</title>
  <style>
    body {
      margin: 0;
      padding: 0;
      background-color: #f5f0eb;
      font-family: Georgia, 'Times New Roman', serif;
      color: #2c1a0e;
    }
    .wrapper {
      max-width: 560px;
      margin: 40px auto;
      background-color: #fffdf9;
      border-radius: 12px;
      overflow: hidden;
      box-shadow: 0 4px 24px rgba(0,0,0,0.08);
    }
    .header {
      background-color: #2c1a0e;
      padding: 36px 40px;
      text-align: center;
    }
    .header h1 {
      margin: 0;
      color: #e8c98a;
      font-size: 28px;
      letter-spacing: 1px;
    }
    .header p {
      margin: 8px 0 0;
      color: #c9a96e;
      font-size: 14px;
    }
    .body {
      padding: 36px 40px;
    }
    .body p {
      font-size: 16px;
      line-height: 1.7;
      margin: 0 0 20px;
    }
    .highlight {
      color: #a0522d;
      font-weight: bold;
    }
    .cta-wrapper {
      text-align: center;
      margin: 32px 0;
    }
    .cta {
      display: inline-block;
      background-color: #2c1a0e;
      color: #e8c98a !important;
      text-decoration: none;
      padding: 14px 36px;
      border-radius: 8px;
      font-size: 16px;
      letter-spacing: 0.5px;
    }
    .divider {
      border: none;
      border-top: 1px solid #e8ddd0;
      margin: 28px 0;
    }
    .footer {
      padding: 0 40px 32px;
      font-size: 13px;
      color: #9e8878;
      line-height: 1.6;
    }
  </style>
</head>
<body>
  <div class="wrapper">
    <div class="header">
      <h1>☕ Coffee on Us</h1>
      <p>Your friend wants to treat you</p>
    </div>
    <div class="body">
      <p>Hi <span class="highlight">{{refereeName}}</span>,</p>
      <p>
        <span class="highlight">{{referrerName}}</span> thinks you deserve a great cup of coffee —
        and they're willing to prove it. They've invited you to join <strong>Coffix</strong>,
        and your first order comes with a treat on them.
      </p>
      <p>
        Download the Coffix app, sign up, and make your first purchase. It's that simple.
      </p>
      <div class="cta-wrapper">
        <a href="{{appDownloadUrl}}" class="cta">Download Coffix</a>
      </div>
      <hr class="divider" />
      <p style="font-size:14px; color:#7a6555;">
        This invite was sent by <strong>{{referrerName}}</strong> ({{referrerEmail}}).
        If you weren't expecting this, you can safely ignore it.
      </p>
    </div>
    <div class="footer">
      © Coffix · You're receiving this because a friend invited you.
    </div>
  </div>
</body>
</html>
```

### Template Variables


| Variable             | Source                                 |
| -------------------- | -------------------------------------- |
| `{{refereeName}}`    | Name entered by referrer on page [21]  |
| `{{referrerName}}`   | Display name of the referring customer |
| `{{referrerEmail}}`  | Email of the referring customer        |
| `{{appDownloadUrl}}` | App Store / Play Store deep link       |


---

### `referrals` Status Field


| Value      | Meaning                                                                  |
| ---------- | ------------------------------------------------------------------------ |
| `pending`  | Referee has not signed up yet                                            |
| `active`   | Referee signed up; 7-day purchase window is open                         |
| `rewarded` | Referee made first purchase within 7 days; $5 coupon granted to both referrer and referee |
| `expired`  | Referee did not purchase within 7 days; reward forfeited                 |
| `invalid`  | Self-referral or fraud detected; reward blocked                          |


