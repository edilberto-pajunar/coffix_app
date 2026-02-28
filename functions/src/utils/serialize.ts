function isFirestoreTimestamp(value: unknown): value is { toDate: () => Date } {
  return (
    typeof value === "object" &&
    value !== null &&
    "toDate" in value &&
    typeof (value as { toDate: () => Date }).toDate === "function"
  );
}

export function serializeForJson<T>(data: T): T {
  if (data === null || data === undefined) {
    return data;
  }
  if (isFirestoreTimestamp(data)) {
    return data.toDate().toISOString() as unknown as T;
  }
  if (Array.isArray(data)) {
    return data.map(serializeForJson) as unknown as T;
  }
  if (typeof data === "object") {
    return Object.fromEntries(
      Object.entries(data).map(([k, v]) => [k, serializeForJson(v)]),
    ) as unknown as T;
  }
  return data;
}
