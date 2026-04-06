# Rate Limiting

## Why

Without rate limiting, the following attack vectors are open:

- **OTP brute-force** – an attacker can hammer `POST /otp/verify` until they guess a 6-digit code (max 1 000 000 attempts).
- **OTP flooding** – repeated calls to `POST /otp/send` exhaust the Resend email quota and spam the user's inbox.
- **Auth abuse** – repeated sign-in attempts against Firebase Auth can be used to enumerate accounts.
- **Credit / payment manipulation** – rapid repeat calls to `/credit` or `/payment` endpoints risk double-spend or data races.

---

## Recommended Library

Use [`express-rate-limit`](https://github.com/express-rate-limit/express-rate-limit) — lightweight, no extra infrastructure, works with the existing Express setup.

```bash
npm --prefix functions install express-rate-limit
```

For distributed / multi-instance deployments (Cloud Functions scales horizontally), pair it with a shared store:

```bash
npm --prefix functions install rate-limit-firestore
# or
npm --prefix functions install rate-limit-redis  # if Redis is available
```

Without a shared store the in-memory window resets per cold-start, so limits are only enforced within a single function instance.

---

## Rate Limit Policy Per Route Group

| Route group | Window | Max requests | Scope | Rationale |
|---|---|---|---|---|
| `POST /otp/send` | 15 min | 5 | per UID (authenticated) | Prevents inbox flooding; 5 resends in 15 min is generous |
| `POST /otp/verify` | 15 min | 10 | per UID | 10 guesses per window; OTP also expires independently |
| `POST /auth/*` | 10 min | 10 | per IP | Protects unauthenticated sign-in/sign-up surface |
| `POST /payment/*` | 1 min | 10 | per UID | Prevents payment request storms |
| `POST /credit/*` | 1 min | 20 | per UID | Allows normal usage; blocks scripted abuse |
| All other routes | 1 min | 60 | per IP | General API protection |

---

## Implementation

### 1. Create `functions/src/middleware/rateLimiter.ts`

```typescript
import rateLimit from "express-rate-limit";
import { Request, Response } from "express";
import { AuthenticatedRequest } from "./auth";

const tooManyRequestsResponse = (_req: Request, res: Response) => {
  res.status(429).json({
    success: false,
    message: "Too many requests. Please try again later.",
  });
};

/** Keyed by Firebase UID when available, falls back to IP. */
const keyByUid = (req: Request): string => {
  const uid = (req as AuthenticatedRequest).user?.uid;
  return uid ?? (req.ip ?? "unknown");
};

export const otpSendLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 5,
  keyGenerator: keyByUid,
  handler: tooManyRequestsResponse,
  standardHeaders: true,
  legacyHeaders: false,
});

export const otpVerifyLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 10,
  keyGenerator: keyByUid,
  handler: tooManyRequestsResponse,
  standardHeaders: true,
  legacyHeaders: false,
});

export const authLimiter = rateLimit({
  windowMs: 10 * 60 * 1000,
  max: 10,
  handler: tooManyRequestsResponse,
  standardHeaders: true,
  legacyHeaders: false,
});

export const paymentLimiter = rateLimit({
  windowMs: 60 * 1000,
  max: 10,
  keyGenerator: keyByUid,
  handler: tooManyRequestsResponse,
  standardHeaders: true,
  legacyHeaders: false,
});

export const creditLimiter = rateLimit({
  windowMs: 60 * 1000,
  max: 20,
  keyGenerator: keyByUid,
  handler: tooManyRequestsResponse,
  standardHeaders: true,
  legacyHeaders: false,
});

export const globalLimiter = rateLimit({
  windowMs: 60 * 1000,
  max: 60,
  handler: tooManyRequestsResponse,
  standardHeaders: true,
  legacyHeaders: false,
});
```

### 2. Apply limiters in each router

**`otp/router.ts`** — apply before `requiredAuth` so the limit fires even on bad tokens:

```typescript
import { otpSendLimiter, otpVerifyLimiter } from "../middleware/rateLimiter";

otpRouter.post("/send",  requirePost, otpSendLimiter,   requiredAuth, handler);
otpRouter.post("/verify", requirePost, otpVerifyLimiter, requiredAuth, handler);
```

**`auth/route.ts`**:

```typescript
import { authLimiter } from "../middleware/rateLimiter";
authRouter.use(authLimiter);
```

**`windcave/router.ts`** (payment):

```typescript
import { paymentLimiter } from "../middleware/rateLimiter";
windcaveRouter.use(paymentLimiter);
```

**`coffixCredit/router.ts`**:

```typescript
import { creditLimiter } from "../middleware/rateLimiter";
coffixCreditRouter.use(creditLimiter);
```

**`api.ts`** — global fallback applied before all routers:

```typescript
import { globalLimiter } from "./middleware/rateLimiter";
api.use(globalLimiter);
```

---

## Response Format

When a limit is exceeded the API returns:

```
HTTP 429 Too Many Requests
Retry-After: <seconds>
RateLimit-Limit: <max>
RateLimit-Remaining: 0
RateLimit-Reset: <epoch seconds>
```

```json
{ "success": false, "message": "Too many requests. Please try again later." }
```

The Flutter client should surface a friendly message and disable the relevant button for the duration of the `Retry-After` window.

---

## OTP-Specific Hardening (Firestore-layer)

`express-rate-limit` alone resets on cold-start. For the OTP flow, add a Firestore-backed attempt counter as a second line of defence:

1. On every failed `POST /otp/verify`, increment `otp/{docId}.attempts` (already done in the current implementation).
2. Before processing a verify request, reject if `attempts >= 10`.
3. On `POST /otp/send`, count pending OTP documents created by `userId` in the last 15 minutes and reject if `>= 5`.

This is cold-start-safe and survives horizontal scaling with no extra infrastructure.

---

## Testing Locally

```bash
# Start emulator
npm --prefix functions run serve

# Trigger the OTP send limit (6th request should return 429)
for i in $(seq 1 6); do
  curl -s -o /dev/null -w "%{http_code}\n" \
    -X POST http://localhost:5001/<project>/us-central1/api/otp/send \
    -H "Authorization: Bearer <id-token>" \
    -H "Content-Type: application/json" \
    -d '{"email":"test@example.com"}'
done
```
