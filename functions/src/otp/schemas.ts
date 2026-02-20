import { z } from "zod";

export const sendEmailOTPSchema = z.object({
  // optional; if provided must match the authenticated user's email
  email: z.email(),
});

export const verifyEmailOTPSchema = z.object({
  otp: z.string().regex(/^\d{6}$/, "OTP must be exactly 6 digits"),
});
