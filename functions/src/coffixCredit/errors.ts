export class InsufficientCreditError extends Error {
  constructor(
    public creditAvailable: number,
    public required: number,
  ) {
    super(
      `Insufficient credit. Available: ${creditAvailable}, required: ${required}`,
    );
  }
}

export class MinCreditError extends Error {
  constructor(public min: number) {
    super(`Amount must be at least ${min}`);
  }
}
