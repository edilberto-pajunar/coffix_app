import express from "express";
import { requirePost } from "../middleware/method";
import { createTokenBodySchema } from "./schema";
import { logger } from "firebase-functions";

const router = express.Router();

router.post("/token", requirePost, async (request, response) => {
  logger.info(process.env.FUNCTIONS_EMULATOR);
  const tokenEndpointEnabled =
    process.env.FUNCTIONS_EMULATOR === "true" ||
    process.env.FIREBASE_TOKEN_ENDPOINT_ENABLED === "true";

  if (!tokenEndpointEnabled) {
    return response.status(403).json({
      success: false,
      message:
        "Token endpoint disabled. Set FIREBASE_TOKEN_ENDPOINT_ENABLED=true (or use the emulator).",
    });
  }

  const validation = createTokenBodySchema.safeParse(request.body);
  if (!validation.success) {
    const errors = validation.error.issues
      .map((i) => `${i.path.join(".")}: ${i.message}`)
      .join(", ");
    return response.status(400).json({ success: false, errors });
  }

  const webApiKey = process.env.WEB_API_KEY;
  if (!webApiKey) {
    return response.status(500).json({
      success: false,
      message: "Missing WEB_API_KEY",
    });
  }

  try {
    const signInUrl = `https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${encodeURIComponent(
      webApiKey,
    )}`;

    const res = await fetch(signInUrl, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Accept: "application/json",
      },
      body: JSON.stringify({
        email: validation.data.email,
        password: validation.data.password,
        returnSecureToken: true,
      }),
      signal: AbortSignal.timeout(15000),
    });

    const payload = (await res.json().catch(() => null)) as any;

    if (!res.ok) {
      const message: string | undefined = payload?.error?.message;
      const status = message === "INVALID_PASSWORD" ? 401 : 400;
      return response.status(status).json({
        success: false,
        message: "Firebase sign-in failed",
        error: message ?? payload ?? "unknown_error",
      });
    }

    return response.status(200).json({
      success: true,
      idToken: payload?.idToken,
      refreshToken: payload?.refreshToken,
      expiresIn: payload?.expiresIn,
      localId: payload?.localId,
    });
  } catch (e) {
    console.error("Firebase token error:", e);
    return response.status(502).json({
      success: false,
      message: "Firebase sign-in failed",
    });
  }
});

export default router;
