import { firestore } from "../config/firebaseAdmin";
import { nowNZ } from "../utils/nz_time";
import { z } from "zod";
import { AddLogSchema } from "./schema";

type AddLogData = z.infer<typeof AddLogSchema>;

export async function addLog(data: AddLogData): Promise<string> {
  const ref = firestore.collection("logs").doc();
  await ref.set({
    docId: ref.id,
    ...data,
    time: new Date(),
  });
  return ref.id;
}
