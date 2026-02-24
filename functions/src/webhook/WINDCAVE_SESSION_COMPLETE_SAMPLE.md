# Windcave session complete — sample payload

Sample response when fetching a completed Windcave session (e.g. GET session by id or notification payload). Use this shape to validate webhook/API responses and to type interfaces.

## Session (complete, with transaction)

```json
{
  "id": "0000060000324512067bb17ae8bcbf49",
  "state": "complete",
  "type": "purchase",
  "amount": "25.00",
  "currency": "NZD",
  "currencyNumeric": 554,
  "merchantReference": "1234ABC",
  "methods": [
    "card",
    "applepay",
    "googlepay"
  ],
  "expires": "2026-02-26T19:39:34Z",
  "callbackUrls": {
    "approved": "https://youtube.com/",
    "declined": "https://example.com/fail",
    "cancelled": "https://example.com/cancel"
  },
  "notificationUrl": "https://c837-136-158-11-147.ngrok-free.app/coffix-app-dev/us-central1/v1/webhook",
  "customer": {
    "firstName": "",
    "lastName": "",
    "email": "pajunar0@gmail.com",
    "phoneNumber": "",
    "homePhoneNumber": "",
    "account": ""
  },
  "storeCard": false,
  "clientType": "internet",
  "links": [
    {
      "href": "https://uat.windcave.com/api/v1/sessions/0000060000324512067bb17ae8bcbf49",
      "rel": "self",
      "method": "GET"
    },
    {
      "href": "https://uat.windcave.com/api/v1/transactions/00000006001763f9",
      "rel": "transaction",
      "method": "GET"
    }
  ],
  "transactions": [
    {
      "id": "00000006001763f9",
      "username": "MetroRetailLtd_dev",
      "authorised": true,
      "allowRetry": false,
      "retryIndicator": "",
      "reCo": "00",
      "responseText": "APPROVED",
      "authCode": "006054",
      "acquirer": {
        "name": "Undefined",
        "mid": "10000000",
        "tid": "10001126",
        "reCo": "00",
        "responseText": "APPROVED"
      },
      "type": "purchase",
      "method": "googlepay",
      "localTimeZone": "NZT",
      "dateTimeUtc": "2026-02-23T19:39:46Z",
      "dateTimeLocal": "2026-02-24T08:39:46+13:00",
      "settlementDate": "2026-02-24",
      "amount": "25.00",
      "balanceAmount": "0.00",
      "currency": "NZD",
      "currencyNumeric": 554,
      "clientType": "internet",
      "merchantReference": "1234ABC",
      "card": {
        "cardNumber": "411111........11",
        "dateExpiryMonth": "12",
        "dateExpiryYear": "28",
        "type": "visa"
      },
      "cvc2ResultCode": "P",
      "traceId": "012345678912345___",
      "storedCardIndicator": "single",
      "notificationUrl": "https://c837-136-158-11-147.ngrok-free.app/coffix-app-dev/us-central1/v1/webhook",
      "customer": {
        "firstName": "",
        "lastName": "",
        "email": "pajunar0@gmail.com",
        "phoneNumber": "",
        "homePhoneNumber": "",
        "account": ""
      },
      "sessionId": "0000060000324512067bb17ae8bcbf49",
      "browser": {
        "ipAddress": "136.158.11.147",
        "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36"
      },
      "isSurcharge": false,
      "amountTotal": "25.00",
      "liabilityIndicator": "standard",
      "links": [
        {
          "href": "https://uat.windcave.com/api/v1/transactions/00000006001763f9",
          "rel": "self",
          "method": "GET"
        },
        {
          "href": "https://uat.windcave.com/api/v1/sessions/0000060000324512067bb17ae8bcbf49",
          "rel": "session",
          "method": "GET"
        },
        {
          "href": "https://uat.windcave.com/api/v1/transactions",
          "rel": "refund",
          "method": "POST"
        }
      ]
    }
  ]
}
```

## Notable fields

| Field | Description |
|-------|-------------|
| `state` | `"complete"` when payment is done |
| `transactions[].authorised` | `true` if payment approved |
| `transactions[].responseText` | e.g. `"APPROVED"` |
| `transactions[].sessionId` | Links transaction to session |
| `transactions[].links` | Includes `rel: "refund"` for refunds |
