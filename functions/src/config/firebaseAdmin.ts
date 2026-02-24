import * as admin from "firebase-admin";

const SECONDARY_APP = "printer";

if (admin.apps.length === 0) {
  admin.initializeApp();
}

export const firestore = admin.firestore();
export const auth = admin.auth();
export const timestamp = admin.firestore.Timestamp;
export const fieldValue = admin.firestore.FieldValue;

const printerProjectId = process.env.PRINTER_PROJECT_ID;
const printerPrivateKey = process.env.PRINTER_PRIVATE_KEY;
const printerClientEmail = process.env.PRINTER_CLIENT_EMAIL;

if (!printerProjectId || !printerClientEmail || !printerPrivateKey) {
  throw new Error(
    "Missing printer env vars: PRINTER_PROJECT_ID / PRINTER_CLIENT_EMAIL / PRINTER_PRIVATE_KEY",
  );
}

if (!admin.apps.find((app) => app?.name === SECONDARY_APP)) {
  admin.initializeApp(
    {
      credential: admin.credential.cert({
        projectId: printerProjectId,
        clientEmail: printerClientEmail,
        privateKey: printerPrivateKey?.replace(/\\n/g, "\n"),
      }),
    },
    SECONDARY_APP,
  );
}

export const printerApp = admin.app(SECONDARY_APP);
export const printerFirestore = printerApp.firestore();
