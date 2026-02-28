const TOPUP_PREFIX = "topup:";

export function getTopupMerchantReference(customerId: string) {
  return `${TOPUP_PREFIX}${customerId}`;
}

export function parseTopupMerchantReference(
  merchantReference: string,
): string | null {
  if (!merchantReference.startsWith(TOPUP_PREFIX)) return null;
  return merchantReference.slice(TOPUP_PREFIX.length);
}
