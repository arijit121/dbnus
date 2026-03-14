// src/routes/fcm.routes.ts
import { Router } from "express";
import { sendFcmNotification } from "../controllers/fcm.controller.js";

const router = Router();

/**
 * @openapi
 * /fcm/fcm-send:
 *   post:
 *     summary: Send an FCM Push Notification
 *     tags: [Notifications]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - token
 *               - title
 *               - body
 *             properties:
 *               token:
 *                 type: string
 *                 description: FCM device token
 *                 example: fmW3DHP43T6dq0jwEotArI:APA91bGbKhCgw9UWo3WD9Zi1tZJ9HbihIyb59seEbUqGwxpO-g_2n3FzG3r9G5hUnIg76IsCVi2DxQYuYpz8IKGFoZFJRA0sZsmeNHr6x4fGKUF2-aTaGDw
 *               title:
 *                 type: string
 *                 description: Notification title
 *                 example: Silent Notification
 *               message:
 *                 type: string
 *                 description: Notification message
 *                 example: test
 *               body:
 *                 type: string
 *                 description: Notification body with HTML support
 *                 example: <p>This is<sub> subscript</sub> and <sup>superscript</sup></p>
 *               image:
 *                 type: string
 *                 description: URL image for the notification
 *                 example: https://res.genupathlabs.com/genu_path_lab/GenuPushImage/900X450_1695990869.jpg
 *               ActionURL:
 *                 type: string
 *                 description: URL to open upon interacting with the notification
 *                 example: http://gplab.in/m04oLk
 *               data:
 *                 type: object
 *                 description: Optional custom data payload
 *     responses:
 *       200:
 *         description: Notification sent successfully
 *       500:
 *         description: Error sending notification
 */
router.post("/fcm-send", sendFcmNotification);

export default router;
