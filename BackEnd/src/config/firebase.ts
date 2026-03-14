// src/config/firebase.ts
import admin from 'firebase-admin';
import { readFileSync } from 'fs';

const serviceAccount = JSON.parse(
  readFileSync('dbnus-df986-firebase-adminsdk-mygbi-ae401389da.json', 'utf8')
);

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://sastasundar-8f573-default-rtdb.firebaseio.com"
});

export default admin;
