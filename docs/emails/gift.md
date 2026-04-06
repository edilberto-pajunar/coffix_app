# Gift Email

Sent when a user shares Coffix credit with another user.

---

## API Endpoint

```
POST /v1/email/gift
Content-Type: application/json
```

No auth required (internal/test endpoint).

---

## Request Body

| Field | Type | Required | Description |
|---|---|---|---|
| `to` | `string` | ✅ | Recipient email address |
| `senderFirstName` | `string` | ✅ | Gift sender's first name |
| `senderLastName` | `string` | ✅ | Gift sender's last name |
| `amount` | `number` | ✅ | Gift amount (positive number) |
| `recipientFirstName` | `string` | — | Recipient's first name (optional personalisation) |

### Example

```json
{
  "to": "jane@example.com",
  "senderFirstName": "John",
  "senderLastName": "Smith",
  "amount": 10.00,
  "recipientFirstName": "Jane"
}
```

---

## Template

**Firestore collection:** `emails`  
**Document ID:** `GIFT_NOTIFICATION`

| Field | Type | Description |
|---|---|---|
| `subject` | `string` | Subject line — may contain `{{ PLACEHOLDER }}` tokens |
| `content` | `string` | HTML body fragment — injected into the shared email shell |

### Placeholders

| Placeholder | Replaced with |
|---|---|
| `{{ SENDER_FULLNAME }}` | Sender's full name (`firstName lastName`) |
| `{{ RECIPIENT_FIRST_NAME }}` | Recipient's first name (empty string if not provided) |
| `{{ AMOUNT }}` | Gift amount formatted to 2 decimal places (e.g. `10.00`) |
| `{{ DATE }}` | Current date in NZ locale (e.g. `7/04/2026`) |

---

## Response

```json
{ "success": true, "message": "Gift email sent" }
```

On failure:

```json
{ "success": false, "message": "<reason>" }
```

---

## Notes

- If the `GIFT_NOTIFICATION` document is missing from Firestore the endpoint returns 500 — add the document before using this endpoint.
- The HTML content is wrapped in the shared Coffix email shell (`wrapInEmailShell`) before sending.
- Also called internally by `coffixCredit/service.ts → shareCredit()` after a successful gift transaction.
