export class WindcaveError extends Error {
  constructor(
    public status: number,
    public data: any,
    message?: string,
  ) {
    super(message ?? "Windcave request failed");
  }
}
