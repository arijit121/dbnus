// src/routes/fcm.routes.ts
import { Router } from "express";
import { sendFcmNotification } from "../controllers/fcm.controller.js";

const router = Router();

/**
 * @openapi
 * /fcm-send:
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
 *               title:
 *                 type: string
 *                 description: Notification title
 *               body:
 *                 type: string
 *                 description: Notification body
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
