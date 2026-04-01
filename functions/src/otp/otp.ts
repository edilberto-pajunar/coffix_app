export interface OTP {
  docId: string;
  otp: string;
  status: "pending" | "verified";
  createdAt: Date;
  expirationDate: Date;
  to: string;
  userId: string;
}
