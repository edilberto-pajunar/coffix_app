# Email System

## What It Means

Every transactional email sent by Coffix shares a single visual wrapper:

- **Background** – very light grey (`#f5f5f5`) fills the full page; the content column (900 px wide, white `#ffffff`, no border) sits centred inside it.
- **Logo** – the Coffix logo (orange) is placed at the top-centre of every email, pulled from the `LOGO_URL` environment variable.
- **Text** – black (`#1a1a1a`) on white; no branded colour inside the body copy.
- **Content** – the subject line and body HTML for each email type come from a document in the Firestore `emails` collection (not hard-coded in source).

---

## Architecture

### 1. The shell — `wrapInEmailShell`

`functions/src/utils/emailShell.ts`

Wraps any HTML content fragment in the full email document: `<html>`, `<head>`, outer grey `<body>`, and the 900 px centred `<table>` with the logo row on top.

Every email type calls this once before sending. It means visual consistency is guaranteed by a single function — change the shell once and every email updates automatically.

### 2. Template variables — `renderTemplate`

`functions/src/utils/renderEmailTemplate.ts`

Replaces `{{ PLACEHOLDER }}` tokens in the body HTML with runtime values (recipient name, amounts, URLs, etc.).

### 3. Email content — Firestore `emails` collection

Each document ID corresponds to an email type:

| Document ID | Used by |
|---|---|
| `GIFT_NOTIFICATION` | Gift credit emails (`coffixCredit/service.ts`) |
| `REFERRAL` | Referral invite emails (`referrals/service.ts`) |
| *(add more as needed)* | |

Each document holds two fields:

| Field | Type | Description |
|---|---|---|
| `subject` | `string` | Email subject line (may contain `{{ PLACEHOLDER }}` tokens) |
| `content` | `string` | Body HTML fragment — injected into the shell; may contain `{{ PLACEHOLDER }}` tokens |

Storing templates in Firestore means copy, links, and layout can be updated without redeploying functions.

### 4. Sending — Resend API

All emails are dispatched via the [Resend](https://resend.com) API using the `RESEND_API_KEY` and `RESEND_FROM_EMAIL` environment variables (set in `functions/.env`).

---

## Flow (per email send)

```
Service function
  │
  ├─ 1. Fetch emails/<DOC_ID> from Firestore  →  { subject, content }
  │
  ├─ 2. renderTemplate(content, variables)    →  HTML fragment with tokens replaced
  │
  ├─ 3. wrapInEmailShell(fragment)            →  Full HTML document (logo + grey bg)
  │
  └─ 4. POST to Resend API                    →  Email delivered
```

---

## Adding a New Email Type

1. **Create the Firestore document** – add a document to the `emails` collection with a unique ID (e.g. `ORDER_CONFIRMATION`). Populate `subject` and `content`.
2. **Define placeholders** – use `{{ PLACEHOLDER_NAME }}` tokens in `content` wherever dynamic values are needed.
3. **Call the helpers in your service**:

```typescript
import { renderTemplate } from "../utils/renderEmailTemplate";
import { wrapInEmailShell } from "../utils/emailShell";

const snap = await firestore.collection("emails").doc("ORDER_CONFIRMATION").get();
const data = snap.data();
if (!data) { /* handle missing template */ }

const html = wrapInEmailShell(
  renderTemplate(data.content, { ORDER_NUMBER: "...", TOTAL: "..." })
);

// POST html to Resend
```

4. **Document the placeholders** in a new `.md` file under `docs/` (follow the pattern in `gift_email_template.md`).

---

## Environment Variables

| Variable | Description |
|---|---|
| `RESEND_API_KEY` | Resend API secret key |
| `RESEND_FROM_EMAIL` | Verified sender address (e.g. `hello@coffix.co.nz`) |
| `LOGO_URL` | Publicly accessible URL to the orange Coffix logo image |
| `APP_DOWNLOAD_URL` | App store / download link used in some email bodies |

---

## Notes

- The shell uses an HTML `<table>` layout (not `<div>`) for maximum email client compatibility.
- The 900 px fixed width renders well on desktop clients; mobile clients reflow naturally.
- If a Firestore template document is missing the service logs a warning and skips the email — it never fails the parent transaction.
