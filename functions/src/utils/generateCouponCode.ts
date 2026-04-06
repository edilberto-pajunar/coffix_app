import { randomInt } from "crypto";

const ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
const LENGTH = 6;

export function generateCouponCode(): string {
  let result = "";
  for (let i = 0; i < LENGTH; i++) {
    result += ALPHABET[randomInt(ALPHABET.length)];
  }
  return `COFFIX-${result}`;
}
