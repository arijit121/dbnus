// src/config/firebase.ts
import admin from 'firebase-admin';

if (!process.env.FIREBASE_SERVICE_ACCOUNT) {
  throw new Error("Missing FIREBASE_SERVICE_ACCOUNT environment variable.");
}

const serviceAccountData = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);

// Ensure private_key has correct newline sequences interpreted from the JSON parse
const privateKey = serviceAccountData.private_key
  ? serviceAccountData.private_key.replace(/\\n/g, "\n")
  : undefined;

admin.initializeApp({
  credential: admin.credential.cert({
    projectId: serviceAccountData.project_id,
    clientEmail: serviceAccountData.client_email,
    privateKey: privateKey,
  }),
  databaseURL: process.env.FIREBASE_DATABASE_URL
});

export default admin;
