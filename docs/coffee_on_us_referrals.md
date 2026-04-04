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

| Variable | Source |
|---|---|
| `{{refereeName}}` | Name entered by referrer on page [21] |
| `{{referrerName}}` | Display name of the referring customer |
| `{{referrerEmail}}` | Email of the referring customer |
| `{{appDownloadUrl}}` | App Store / Play Store deep link |

---

### Suggested `referrals` Status Field

Add a `status` field to the referral document to track state:

| Value | Meaning |
|---|---|
| `pending` | Referee has not signed up yet |
| `active` | Referee signed up and passed validation |
| `rewarded` | Referee made first purchase; reward granted to referrer |
| `invalid` | Self-referral or fraud detected; reward blocked |

