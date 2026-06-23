// src/config/firebase.ts
import admin from 'firebase-admin';
import fs from 'fs';
import path from 'path';

if (!process.env.FIREBASE_SERVICE_ACCOUNT) {
  throw new Error("Missing FIREBASE_SERVICE_ACCOUNT environment variable.");
}

let serviceAccountData: any;
const serviceAccountValue = process.env.FIREBASE_SERVICE_ACCOUNT.trim();

if (serviceAccountValue.startsWith('{')) {
  serviceAccountData = JSON.parse(serviceAccountValue);
} else {
  // Resolve relative to the root directory
  const resolvedPath = path.resolve(process.cwd(), serviceAccountValue);
  serviceAccountData = JSON.parse(fs.readFileSync(resolvedPath, 'utf8'));
}

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
