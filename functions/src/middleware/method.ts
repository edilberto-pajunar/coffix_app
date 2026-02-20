import { Request, Response, NextFunction } from "express";

/**
 *
 * For routes that only allow POST requests
 */
export const requirePost = (
  request: Request,
  response: Response,
  next: NextFunction,
) => {
  if (request.method !== "POST") {
    response
      .status(405)
      .send({ success: false, message: "Method not allowed" });
    return;
  }
  next();
};
