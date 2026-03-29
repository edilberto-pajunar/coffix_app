export const TOPUP_PREFIX = "topup:";
export const ORDER_PREFIX = "order:";

export function getTopupMerchantReference(customerId: string) {
  return `${TOPUP_PREFIX}${customerId}`;
}

export function getOrderMerchantReference(customerId: string, orderId: string) {
  return `${ORDER_PREFIX}${customerId}:${orderId}`;
}

export function parseTopupMerchantReference(
  merchantReference: string,
): string | null {
  if (!merchantReference.startsWith(TOPUP_PREFIX)) return null;
  return merchantReference.slice(TOPUP_PREFIX.length);
}

export function parseOrderMerchantReference(
  merchantReference: string,
): { customerId: string; orderId: string } | null {
  if (!merchantReference.startsWith(ORDER_PREFIX)) return null;
  const [customerId, orderId] = merchantReference
    .slice(ORDER_PREFIX.length)
    .split(":");
  return { customerId: customerId ?? "", orderId: orderId ?? "" };
}
