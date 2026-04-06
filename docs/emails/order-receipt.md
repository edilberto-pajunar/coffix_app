# Order Receipt Email

Sent after a successful order to provide the customer with an itemised receipt.

---

## API Endpoint

```
POST /v1/email/order-receipt
Content-Type: application/json
```

No auth required (internal/test endpoint).

---

## Request Body

| Field | Type | Required | Description |
|---|---|---|---|
| `to` | `string` | ✅ | Recipient email address |
| `orderNumber` | `string` | ✅ | Full order number (last 6 chars shown in email) |
| `storeName` | `string` | ✅ | Store name |
| `storeAddress` | `string` | ✅ | Store address |
| `createdAt` | `string` | ✅ | Order date/time string (pre-formatted) |
| `paymentMethod` | `string` | ✅ | e.g. `Card`, `Apple Pay`, `Coffix Credit` |
| `total` | `number` | ✅ | Order total in dollars (e.g. `24.50`) |
| `items` | `Item[]` | ✅ | Array of order items (min 1) |

### Item object

| Field | Type | Required | Description |
|---|---|---|---|
| `name` | `string` | ✅ | Product name |
| `quantity` | `number` | ✅ | Integer quantity |
| `price` | `number` | ✅ | Unit price in dollars |
| `modifiers` | `string[]` | — | List of modifier names (e.g. `["Oat Milk", "Extra Shot"]`) |

### Example

```json
{
  "to": "customer@example.com",
  "orderNumber": "ORD-2026-001234",
  "storeName": "Coffix Auckland CBD",
  "storeAddress": "123 Queen Street, Auckland",
  "createdAt": "07 Apr 2026, 09:15 am",
  "paymentMethod": "Card",
  "total": 12.50,
  "items": [
    {
      "name": "Flat White",
      "quantity": 1,
      "price": 6.50,
      "modifiers": ["Oat Milk"]
    },
    {
      "name": "Blueberry Muffin",
      "quantity": 1,
      "price": 6.00
    }
  ]
}
```

---

## Template

The HTML template is hardcoded in:

```
functions/src/utils/templates/order_email_template.ts
```

### Placeholders

| Placeholder | Replaced with |
|---|---|
| `{{orderNumber}}` | Last 6 characters of `orderNumber` |
| `{{storeName}}` | Store name |
| `{{storeAddress}}` | Store address |
| `{{createdAt}}` | `createdAt` string as-is |
| `{{paymentMethod}}` | Payment method string |
| `{{total}}` | Total formatted as `$XX.XX` |
| `{{items}}` | Generated HTML rows for each item |

---

## Response

```json
{ "success": true, "message": "Order receipt sent" }
```

On failure:

```json
{ "success": false, "message": "<reason>" }
```

---

## Notes

- Unlike the `/order/send-receipt` endpoint, this endpoint accepts all order data inline — no Firestore lookup, no auth requirement. Use it to test email rendering independently.
- The template is not wrapped in `wrapInEmailShell`; it is a fully self-contained HTML document with its own header/footer styling.
- To update the template, edit `functions/src/utils/templates/order_email_template.ts` and redeploy.
