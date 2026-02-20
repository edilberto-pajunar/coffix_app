# Create Account – Approach

## Gist

When the user signs up with **email** and **password**, they must complete **OTP verification** before the account is considered created. After OTP is verified, the account is created (or confirmed) and the user is signed in.

---

## Flow

1. **Step 1 – Email & password**
   - User enters email and password on the create-account screen.
   - On "Next" (or "Continue"): validate fields, then send OTP to the given email (or trigger backend/Firebase flow that sends the code).

2. **Step 2 – OTP**
   - User is taken to an OTP screen (or same screen switches to OTP input).
   - User enters the code received by email.
   - On submit: verify OTP with backend/Firebase.

3. **Step 3 – Account created**
   - If OTP is valid: create the account (or confirm it), sign the user in, then redirect to home (or next onboarding step).

---

## Screens / UI

| Step | Screen / view             | Content                                                                                |
| ---- | ------------------------- | -------------------------------------------------------------------------------------- |
| 1    | Create account (existing) | Email field, password field, "Next" button.                                            |
| 2    | Verify OTP                | Title/instruction, OTP input (e.g. 6 digits), "Verify" button, optional "Resend code". |
| 3    | —                         | Navigate to app (e.g. home).                                                           |

Optional: combine step 1 and 2 in one page with two "modes" (email/password form vs OTP form) to avoid an extra route.

---

## Technical approach

- **Auth layer**
  - Keep **AuthCubit** as the single place for auth state (loading, success, error, needsVerification, etc.).
  - Add methods such as:
    - `createAccountWithEmail({ required String email, required String password })`  
      → calls repo to create user and send OTP (or send verification).
    - `verifyOtp({ required String code })` or `verifyEmailOtp({ required String code })`  
      → calls repo to verify code and, on success, marks user as verified / signs in.
  - **AuthRepository** (and impl) should:
    - Create user with email/password (e.g. Firebase `createUserWithEmailAndPassword`).
    - Send OTP to email: either via **custom backend** (backend sends email with code and validates it) or, if you use **Firebase Email Link** only, document that flow instead of OTP.
    - Expose a **verify** method that checks the code (backend or Firebase, depending on choice).

- **OTP delivery**
  - **Option A – Custom backend:** Backend generates a 6-digit (or similar) code, stores it with the pending user/email and TTL, sends it by email. App calls backend to verify the code; on success, backend may create/finalize the user and return a token, or you keep using Firebase and only use backend for OTP.
  - **Option B – Firebase Email Link:** Use Firebase’s email verification link; user taps link instead of typing OTP. No "OTP screen" in app; you’d document "Verify email" instead of "Enter OTP" in the flow.

- **Routing**
  - After successful OTP verification (or link click), router redirects to home (or shell).
  - If user leaves the app before verifying, on next open they can be shown "Verify your email" (or OTP screen) until verified.

- **State**
  - Example states: `initial` → `loading` → `otpSent` (show OTP screen) → `verified` / `authenticated` or `error`.
  - Persist "pending email" (e.g. in cubit or a small local store) so that when the user opens the OTP screen you know which email to verify and can resend.

---

## Summary

| Phase | Action                                                                      |
| ----- | --------------------------------------------------------------------------- |
| 1     | User enters email + password → validate → send OTP (or verification email). |
| 2     | User enters OTP (or taps link) → verify with backend/Firebase.              |
| 3     | On success → create/confirm account, sign in → navigate to app.             |

Implement OTP sending and verification in **AuthRepository** (and optional backend), and drive the flow and UI from **AuthCubit** and the create-account / verify-OTP screens.
