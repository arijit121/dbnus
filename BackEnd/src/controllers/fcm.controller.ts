// src/controllers/fcm.controller.ts
import { Request, Response } from "express";
import admin from "../config/firebase.js";
import { sendResponse } from "../utils/response.util.js";

export const sendFcmNotification = async (req: Request, res: Response) => {
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
          "apns-topic": "io.flutter.plugins.firebase.messaging",
        },
      },
    });
    return sendResponse(res, 200, { data: `${result}` }, "Successfully sent FCM notification");
  }
  catch (e) {
    return sendResponse(res, 500, { error: `${e}` }, "Failed to send FCM notification");
  }
};
