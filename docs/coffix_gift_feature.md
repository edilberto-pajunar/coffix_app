# Coffix Gift Feature – Implementation Plan

Page [22] – Share your balance / Send a Gift

---

## Overview

A customer can gift a portion of their Coffix Credit to another person identified by email.

**Constraints:**
- `amount >= minCreditToShare` (from `global` doc)
- `amount <= sender's creditAvailable`

---

## Firestore / Data

### `global` doc

Add field: `minCreditToShare: number`

### `transactions` collection – gift record shape

```ts
{
  docId: string;
  type: "gift";
  senderId: string;          // sender's customerId (uid)
  senderFirstName: string;
  senderLastName: string;
  recipientEmail: string;
  recipientCustomerId?: string; // set only if recipient exists at send time
  amount: number;
  status: "completed";
  createdAt: Timestamp;
}
```

### `emails` collection

Stores the gift notification email template referenced by key (e.g. `"gift_notification"`):

```ts
{
  subject: string;
  body: string; // supports {{senderName}}, {{amount}}, {{recipientFirstName}} placeholders
}
```

---

## Backend – `POST /coffixCredit/share`

### Request body

```ts
{
  recipientFirstName: string;
  recipientLastName: string;
  recipientEmail: string;   // case-insensitive
  amount: number;
}
```

### Steps

1. **Validate** body with Zod schema.
2. **Load global config** – read `minCreditToShare`.
3. **Validate amount** – reject if `amount < minCreditToShare`.
4. **Load sender** from `customers/{senderId}` – reject if not found.
5. **Validate balance** – reject if `sender.creditAvailable < amount`.
6. **Look up recipient** by email in `customers` collection (`where("email", "==", recipientEmail)`).

#### Branch A – Recipient exists

Run a single Firestore transaction:
- Deduct `amount` from `sender.creditAvailable`.
- Add `amount` to `recipient.creditAvailable`.
- Write gift transaction record (with `recipientCustomerId` set).

#### Branch B – Recipient does not exist

Run a single Firestore transaction:
- Deduct `amount` from `sender.creditAvailable`.
- Write gift transaction record (no `recipientCustomerId`; `recipientEmail` stored).

After the transaction, send the gift notification email:
- Fetch template from `emails` doc (key: `"gift_notification"`).
- Interpolate `{{senderName}}`, `{{amount}}`, `{{recipientFirstName}}`.
- Send to `recipientEmail` via the existing email service / Firebase Extension.

### Response

```ts
{ success: true }
```

---

## New-user hook – apply pending gifts on account creation

When a new customer account is created (Firebase Auth `onCreate` trigger or inside the OTP verification flow that finalises the account):

1. Query `transactions` where:
   - `type == "gift"`
   - `recipientEmail == newUser.email` (case-insensitive)
   - `recipientCustomerId` is not set (pending)
   - `createdAt >= now - 30 days`
2. Sum all qualifying `amount` values.
3. In a single Firestore transaction:
   - Set `customers/{newUserId}.creditAvailable += totalGiftAmount`.
   - Back-fill `recipientCustomerId` on each matching transaction doc.

---

## Flutter – `ShareYourBalancePage`

The UI shell already exists (`lib/features/profile/presentation/pages/share_your_balance_page.dart`).

### What needs wiring

1. **Repository / data layer**
   - Add `shareCredit({ recipientFirstName, recipientLastName, recipientEmail, amount })` to the credit repository interface and implementation (HTTP POST to `/coffixCredit/share`).

2. **Cubit (`CreditCubit` or a new `GiftCubit`)**
   - State: `initial | loading | success | error(message)`.
   - Method: `sendGift(...)` – calls repository, emits state.

3. **Page**
   - Replace the `// TODO` stub in `_formKey.currentState?.saveAndValidate()` block with `context.read<GiftCubit>().sendGift(...)`.
   - Show loading indicator while `loading`.
   - Show success dialog / pop on `success`.
   - Show error snackbar on `error`.
   - The `minCreditToShare` value should come from the global config (already loaded elsewhere) so the "Minimum of $15" label and validator reflect the live config value instead of a hardcoded constant.

---

## Validation summary

| Check | Where enforced |
|---|---|
| `amount >= minCreditToShare` | Flutter (client) + Cloud Function |
| `amount <= creditAvailable` | Flutter (client) + Cloud Function (transaction) |
| Valid email format | Flutter (FormBuilderValidators.email) |
| Sender exists | Cloud Function |
| Atomic credit transfer | Firestore transaction |

---

## Files to create / modify

| File | Action |
|---|---|
| `functions/src/coffixCredit/schema.ts` | Add `shareCoffixCreditSchema` |
| `functions/src/coffixCredit/router.ts` | Implement `/share` handler |
| `functions/src/coffixCredit/service.ts` | Add `shareCredit(...)` method to `CoffixCreditService` |
| `functions/src/firebase/service.ts` | Add `findCustomerByEmail`, `createGiftTransaction`, `applyPendingGifts` helpers |
| `functions/src/index.ts` or auth trigger | Wire new-user hook for pending gift backfill |
| `lib/features/credit/data/` | Add share API call in repository impl |
| `lib/features/credit/domain/` | Add use case if following strict clean arch |
| `lib/features/credit/logic/` | Add `GiftCubit` (or extend existing credit cubit) |
| `lib/features/profile/presentation/pages/share_your_balance_page.dart` | Wire cubit, replace TODO |
