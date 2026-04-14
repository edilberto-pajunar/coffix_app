# Windcave Webhook: How It Works

## Overview

When a payment session is created via `WindcaveService.createPaymentSession()`, two URLs are registered with Windcave:

| URL type | Field | Direction | Trigger |
|----------|-------|-----------|---------|
| `notificationUrl` | `notificationUrl` | Windcave → your server | Windcave sends a **server-to-server GET** after payment completes |
| Redirect URLs | `callbackUrls.approved/declined/cancelled` | Windcave → user's browser | Windcave redirects the **user's browser** after payment |

---

## notificationUrl (Server-to-Server GET)

```
GET /webhook?sessionId=<sessionId>
```

Windcave calls this endpoint after each transaction result (approved, declined, cancelled). It sends a plain GET with `sessionId` as a query parameter.

**Our handler:** `webhook/router.ts` — the `GET /` route reads `sessionId`, then calls `WebhookService.handleWebhook(sessionId)`.

**Critical rule:** Your endpoint **must return HTTP 200**. Any non-200 response causes Windcave to retry the notification, which will trigger the webhook a second time.

---

## callbackUrls (Browser Redirects)

After the user completes payment on the Windcave HPP, the browser is redirected to one of:

- `callbackUrls.approved` → `https://www.coffix.co.nz/payment/successful`
- `callbackUrls.declined` → `https://www.coffix.co.nz/payment/failed`
- `callbackUrls.cancelled` → `https://www.coffix.co.nz/payment/cancelled`

These are **browser redirects only** — they do not call your server directly. The Flutter app handles navigation when it detects these deep-link URLs.

---

## Does `getSession()` trigger a webhook?

**No.** Calling `WindcaveService.getSession(sessionId)` is a read-only GET to Windcave's REST API (`/api/v1/sessions/:id`). It fetches the session state and does not cause Windcave to send any notification.

---

## Why the Webhook Can Fire Twice

There are two root causes:

### 1. Non-200 response → Windcave retry
If `handleWebhook` throws an unhandled error and the router returns `500`, Windcave interprets this as a delivery failure and **retries** the `notificationUrl` call. This is the most common cause.

**Fix:** Always return `200`, even on internal errors. Log the error but swallow it at the HTTP layer.

### 2. Race condition in the idempotency check
The naive guard pattern reads status, then writes it in two separate Firestore operations:

```typescript
// ❌ TOCTOU race: two concurrent calls can both pass this check
if (["approved", "declined", "cancelled"].includes(transactionDoc.status)) {
  return;
}
// ... later ...
await updateTransaction({ status: "approved" });
```

If two webhook calls arrive close together (e.g., Windcave fires + app also polls), both can read `"pending"` before either writes `"approved"`.

**Fix:** Use a Firestore transaction to atomically claim processing by setting `status: "processing"` only if the current status is still `"pending"`.

---

## Idempotency Pattern (Current Implementation)

```typescript
// Atomic claim: only one concurrent caller can win this transaction
const claimed = await firestore.runTransaction(async (t) => {
  const ref = firestore.collection("transactions").doc(transactionDoc.docId);
  const snap = await t.get(ref);
  const current = snap.data()?.status;
  if (["approved", "declined", "cancelled", "processing"].includes(current)) {
    return false; // already handled or in-flight, skip
  }
  t.update(ref, { status: "processing", updatedAt: new Date() });
  return true;
});
if (!claimed) return;
```

Transaction statuses and their meanings:

| Status | Set by | Meaning |
|--------|--------|---------|
| `pending` | Order/topup creation | Awaiting payment |
| `processing` | Webhook (atomic claim) | Webhook is actively handling this payment |
| `approved` | Webhook (success path) | Payment completed successfully |
| `declined` | Webhook (declined path) | Payment was declined |
| `cancelled` | Webhook (cancelled path) | Payment was cancelled by user |

---

## Flow Diagram

```
User pays on HPP
       │
       ▼
Windcave processes transaction
       │
       ├──── notificationUrl GET ──────► GET /webhook?sessionId=...
       │                                         │
       │                                  handleWebhook()
       │                                         │
       │                                  getSession() ← read-only, no side effects
       │                                         │
       │                                  Atomic Firestore txn
       │                                  (claim "processing")
       │                                         │
       │                                  Update order + transaction
       │                                         │
       │                                  Return 200 always ◄─── prevents retry
       │
       └──── callbackUrls redirect ──────► User's browser → Flutter app deep-link
```
