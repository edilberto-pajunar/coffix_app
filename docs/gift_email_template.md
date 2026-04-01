# Gift Notification Email Template

Template file: `functions/src/utils/templates/gift_email_template.html`

---

## Firestore setup

This template must be stored in Firestore so the Cloud Function can fetch and render it at send time.

**Collection:** `emails`  
**Document ID:** `GIFT_NOTIFICATION`

### Fields

| Field | Type | Value |
|---|---|---|
| `subject` | `string` | `You received a Coffix gift from {{senderName}}!` |
| `body` | `string` | *(full contents of `gift_email_template.html`)* |

> Paste the entire HTML file content into the `body` field.

---

## Placeholders

The service replaces these at send time (see `functions/src/coffixCredit/service.ts`):

| Placeholder | Replaced with |
|---|---|
| `{{recipientFirstName}}` | Recipient's first name |
| `{{senderName}}` | Sender's full name (`firstName lastName`) |
| `{{amount}}` | Gift amount formatted to 2 decimal places (e.g. `15.00`) |

---

## Preview

When rendered the email shows:

1. **Header** – Coffix brand bar (orange `#f15f2c`)
2. **Body** – personalised greeting, sender name, gift amount in a highlighted box
3. **Footer** – standard Coffix sign-off

---

## Notes

- If the `GIFT_NOTIFICATION` document is missing from Firestore, the function logs a warning and skips the email without failing the gift transaction.
- The `subject` field in Firestore overrides the default fallback `"You received a gift!"` in the service.
- To update the template, edit the HTML file and re-paste the content into Firestore — no function redeploy needed.
