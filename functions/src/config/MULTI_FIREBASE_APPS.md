# Initializing multiple Firebase apps (Admin SDK)

Use a **named app** for each project. The first is the default; the rest are created with `admin.initializeApp(options, appName)`.

## 1. Basic pattern

```ts
import * as admin from "firebase-admin";

// Default app (used by Firebase Functions automatically)
admin.initializeApp();

// Second app: pass options + unique name
admin.initializeApp(
  { projectId: "your-other-project-id" },
  "secondary"
);

// Use default app
const defaultFirestore = admin.firestore();
const defaultAuth = admin.auth();

// Use second app
const secondaryFirestore = admin.app("secondary").firestore();
const secondaryAuth = admin.app("secondary").auth();
```

## 2. Avoid "App already exists"

Initialize each name only once. Use a helper:

```ts
function getOrInitApp(name: string, options?: admin.AppOptions): admin.app.App {
  try {
    return admin.app(name);
  } catch {
    return admin.initializeApp(options ?? {}, name);
  }
}

getOrInitApp("default");
getOrInitApp("secondary", { projectId: "other-project-id" });

const db1 = admin.app("default").firestore();
const db2 = admin.app("secondary").firestore();
```

## 3. Different credentials per app

For a second project with its own service account:

```ts
const secondaryCredential = admin.credential.cert({
  projectId: "other-project",
  clientEmail: "firebase-adminsdk-xxx@other-project.iam.gserviceaccount.com",
  privateKey: process.env.SECONDARY_PRIVATE_KEY?.replace(/\\n/g, "\n"),
});

admin.initializeApp(
  {
    projectId: "other-project",
    credential: secondaryCredential,
  },
  "secondary"
);
```

## 4. Env-based second project (this repo)

In this codebase, the second app is optional and driven by env:

- Set `FIREBASE_SECONDARY_PROJECT_ID` in `.env.local` (or Functions config) to enable the second app.
- Use `getSecondaryFirestore()` or `getSecondaryApp()` from `config/firebaseAdmin`.

**Firestore from 2nd app:**

```ts
import { getSecondaryFirestore } from "./config/firebaseAdmin";

const db = getSecondaryFirestore();
const snapshot = await db.collection("users").doc("abc").get();
await db.collection("orders").add({ total: 100 });
```

**Full app (Firestore, Auth, etc.):**

```ts
import { getSecondaryApp } from "./config/firebaseAdmin";

const app = getSecondaryApp();
const firestore = app.firestore();
const auth = app.auth();
```

## Reference

- [Firebase Admin: Multiple projects](https://firebase.google.com/docs/admin/setup#initialize_multiple_apps)
- [AppOptions](https://firebase.google.com/docs/reference/admin/node/firebase-admin.appoptions)
