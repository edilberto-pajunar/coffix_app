import express from "express";
import { otpRouter } from "./otp/router";

export const api = express();
// Global middleware
api.use(express.json())

// Mount routers
api.use("/otp", otpRouter)