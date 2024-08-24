// src/index.ts
import express, { Express, Request, Response } from "express";
import dotenv from "dotenv";
import { CustomConsole } from "./utils/custom_console";
import admin from 'firebase-admin';
import { readFileSync } from 'fs';

/*
 * Load up and parse configuration details from
 * the `.env` file to the `process.env`
 * object of Node.js
 */
dotenv.config();

/*
 * Create an Express application and get the
 * value of the PORT environment variable
 * from the `process.env`
 */
const app: Express = express();
const port = process.env.PORT || 3000;

app.use(express.json());

// Initialize the Firebase Admin SDK
const serviceAccount = JSON.parse(
  readFileSync('dbnus-df986-firebase-adminsdk-mygbi-ae401389da.json', 'utf8')
);

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://dbnus-df986-default-rtdb.firebaseio.com"
});

/* Define a route for the root path ("/")
 using the HTTP GET method */
app.get("/", (req: Request, res: Response) => {
  res.send("Express + TypeScript Server");
});

app.post("/fcm-send", async (req: Request, res: Response) => {
  try {
    const result: string = await admin.messaging().send({
      token: req.body["token"],
      data: req.body["data"],
      // Set Android priority to "high"
      android: {
        priority: "high",
      },
      // Add APNS (Apple) config
      apns: {
        payload: {
          aps: {
            contentAvailable: true,
          },
        },
        headers: {
          "apns-push-type": "background",
          "apns-priority": "5", // Must be 5 when contentAvailable is set to true.
          "apns-topic": "io.flutter.plugins.firebase.messaging", // bundle identifier "apns-topic": "io.flutter.plugins.firebase.messaging" or "com.domain.appName",
        },
      },
    });
    res.send({ "data": `${result}` });
  }
  catch (e) {
    res.send({ "error": `${e}` });
  }
});

/* Start the Express app and listen
 for incoming requests on the specified port */
app.listen(port, () => {
  CustomConsole.infoLog(`Server is running at http://localhost:${port}`, {tag:"server"});
});