# Windcave Session Payment – Functions & Router

Overview of the functions and router you need to create a payment session with Windcave.

## Router (`src/windcave/router.ts`)

Mount path: **`/windcave`** (see `src/api.ts`).

| Route | Method | Middleware | Handler | Purpose |
|-------|--------|------------|---------|---------|
| `/session` | POST | `requiredAuth` | `createSession` | Create a payment session (server-side) |
| `/fprn` | POST | `verifyFprn` | `fprn` | Handle Windcave FPRN (Final Payment Response Notification) callback |

## cURL: Create Session

Set your base URL to either the emulator or deployed function:

```bash
# Emulator:
export BASE_URL="http://127.0.0.1:5001/<FIREBASE_PROJECT_ID>/us-central1/v1"

# Deployed:
export BASE_URL="https://us-central1-<FIREBASE_PROJECT_ID>.cloudfunctions.net/v1"
```

Then call:

```bash
curl -X POST "$BASE_URL/windcave/session" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <FIREBASE_ID_TOKEN>" \
  -d '{
    "amount": 12.34,
    "currency": "NZD"
  }'
```

## Functions to Implement

### 1. `createSession`

- **Role:** Call Windcave REST API to create a session; return session data (e.g. session ID, `hpp` link, `submitCard` link) to the client.
- **Auth:** Use `requiredAuth` so only authenticated users can create sessions.
- **Input:** Typically `AuthenticatedRequest`; optional body (e.g. amount, currency, return URLs) depending on your Windcave integration.
- **Output:** Session object from Windcave (session ID, state, links for Hosted Payment Page or Hosted Fields).
- **Flow:** Verify Firebase token → (optional) validate body → call Windcave Create Session API with server-stored API username/key → return session payload to client.

### 2. `fprn`

- **Role:** Webhook/callback handler for Windcave’s Final Payment Response Notification (FPRN).
- **Auth:** Use `verifyFprn` to ensure the request comes from Windcave (e.g. signature/hash verification).
- **Input:** POST body from Windcave (payment result, transaction ID, status, etc.).
- **Output:** 200 OK (and optionally store/update payment status in your DB).
- **Flow:** Verify FPRN signature → parse payload → update order/payment in Firestore → respond 200.

## Middleware to Implement

### 1. `requiredAuth` (existing)

- **Location:** `src/middleware/auth.ts`
- **Role:** Ensures the request has a valid Firebase ID token in `Authorization: Bearer <token>`.
- **Use on:** `POST /windcave/session`.

### 2. `verifyFprn`

- **Role:** Validates that the request to `/fprn` is from Windcave (e.g. shared secret / HMAC / query or body hash per Windcave docs).
- **Use on:** `POST /windcave/fprn`.

## Optional Middleware

- **`requirePost`** (`src/middleware/method.ts`): Restrict routes to POST if you want consistency with other routers (e.g. OTP).

## Wiring in the Router

```ts
import { Router } from "express";
import { requiredAuth } from "../middleware/auth";
import { requirePost } from "../middleware/method";
import { createSession } from "./createSession";   // implement
import { verifyFprn } from "../webhook/verifyFprn"; // or local middleware
import { fprn } from "./fprn";                     // implement

const router = Router();

router.post("/session", requirePost, requiredAuth, createSession);
router.post("/fprn", requirePost, verifyFprn, fprn);

export default router;
```

## Summary

| Piece | Purpose |
|-------|--------|
| **Router** | Mount under `/windcave`, define `POST /session` and `POST /fprn`. |
| **createSession** | Server-side Windcave Create Session call; protected by `requiredAuth`. |
| **fprn** | Handle Windcave FPRN callback; protected by `verifyFprn`. |
| **requiredAuth** | Firebase ID token verification for `/session`. |
| **verifyFprn** | Validate FPRN requests for `/fprn`. |

Credentials (API username, API key, FPRN secret) should live in environment variables and never be sent to the client.
