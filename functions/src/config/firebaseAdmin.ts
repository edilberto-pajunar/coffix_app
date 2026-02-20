import * as admin from "firebase-admin";
admin.initializeApp();

export const firestore = admin.firestore();
export const auth = admin.auth();
export const timestamp = admin.firestore.Timestamp;
export const fieldValue = admin.firestore.FieldValue;
