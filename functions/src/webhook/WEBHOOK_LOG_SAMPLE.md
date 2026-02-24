# Webhook log sample

Raw log entries (severity + message) contained a stringified ServerResponse dump. Below is the same information as structured JSON, extracted from the terminal output.

## Entry 1 — Webhook received

```json
{
  "severity": "INFO",
  "message": "Webhook received: {}",
  "webhookRequest": {
    "method": "GET",
    "url": "/?sessionId=0000060000324512067bb17ae8bcbf49",
    "baseUrl": "/webhook",
    "originalUrl": "/webhook?sessionId=0000060000324512067bb17ae8bcbf49",
    "query": {
      "sessionId": "0000060000324512067bb17ae8bcbf49"
    },
    "body": {},
    "headers": {
      "host": "c837-136-158-11-147.ngrok-free.app",
      "user-agent": "PXL1",
      "accept": "*/*",
      "x-forwarded-for": "203.207.60.57",
      "x-forwarded-host": "c837-136-158-11-147.ngrok-free.app",
      "x-forwarded-proto": "https",
      "accept-encoding": "gzip",
      "connection": "keep-alive"
    }
  }
}
```

## Entry 2 — Data (after response sent)

```json
{
  "severity": "INFO",
  "message": "Data:",
  "webhookRequest": {
    "method": "GET",
    "url": "/?sessionId=0000060000324512067bb17ae8bcbf49",
    "baseUrl": "/webhook",
    "originalUrl": "/webhook?sessionId=0000060000324512067bb17ae8bcbf49",
    "query": {
      "sessionId": "0000060000324512067bb17ae8bcbf49"
    },
    "body": {},
    "headers": {
      "host": "c837-136-158-11-147.ngrok-free.app",
      "user-agent": "PXL1",
      "accept": "*/*",
      "x-forwarded-for": "203.207.60.57",
      "x-forwarded-host": "c837-136-158-11-147.ngrok-free.app",
      "x-forwarded-proto": "https",
      "accept-encoding": "gzip",
      "connection": "keep-alive"
    }
  },
  "responseStatus": 200,
  "responseMessage": "OK"
}
```

## Note

Both were **GET** requests with `sessionId` in the query string. The webhook body was empty (`{}`) because GET has no body. For Windcave notification callbacks that send payloads, use **POST** and read `request.body`; for GET (e.g. redirect/callback), use `request.query` (e.g. `sessionId`). Avoid logging `request` or `response` directly—log only `request.method`, `request.query`, and `request.body` to prevent ServerResponse/IncomingMessage dumps in logs.
