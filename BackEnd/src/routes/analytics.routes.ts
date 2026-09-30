// src/routes/analytics.routes.ts
import { Router } from "express";
import {
  getGa4Report,
  getGa4AccessToken,
  getUserFlowReport,
  getUserSpecificReport,
} from "../controllers/analytics.controller.js";

const router = Router();

/**
 * @openapi
 * /analytics/token:
 *   get:
 *     summary: Generate OAuth 2.0 Access Token for GA4 Data API
 *     tags: [Analytics]
 *     responses:
 *       200:
 *         description: OAuth access token generated successfully
 *       500:
 *         description: Error generating access token
 */
router.get("/token", getGa4AccessToken);

/**
 * @openapi
 * /analytics/user-data:
 *   get:
 *     summary: Fetch Per-User Analytics Data (GET)
 *     tags: [Analytics]
 *     parameters:
 *       - in: query
 *         name: userId
 *         schema:
 *           type: string
 *         description: Custom logged-in User ID to filter
 *       - in: query
 *         name: userPseudoId
 *         schema:
 *           type: string
 *         description: Device Pseudo ID / Client ID to filter
 *       - in: query
 *         name: startDate
 *         schema:
 *           type: string
 *         default: "30daysAgo"
 *       - in: query
 *         name: endDate
 *         schema:
 *           type: string
 *         default: "today"
 *     responses:
 *       200:
 *         description: Per-user analytics data fetched successfully
 *       500:
 *         description: Error fetching per-user analytics data
 *   post:
 *     summary: Fetch Per-User Analytics Data (POST)
 *     tags: [Analytics]
 *     requestBody:
 *       required: false
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               userId:
 *                 type: string
 *                 example: "user_12345"
 *               userPseudoId:
 *                 type: string
 *                 example: "123456789.987654321"
 *               startDate:
 *                 type: string
 *                 example: "30daysAgo"
 *               endDate:
 *                 type: string
 *                 example: "today"
 *     responses:
 *       200:
 *         description: Per-user analytics data fetched successfully
 *       500:
 *         description: Error fetching per-user analytics data
 */
router.get("/user-data", getUserSpecificReport);
router.post("/user-data", getUserSpecificReport);

/**
 * @openapi
 * /analytics/user-flow:
 *   get:
 *     summary: Fetch GA4 User Flow / Page Transition Journey Data (GET)
 *     tags: [Analytics]
 *     parameters:
 *       - in: query
 *         name: propertyId
 *         schema:
 *           type: string
 *         default: "455992850"
 *       - in: query
 *         name: startDate
 *         schema:
 *           type: string
 *         default: "30daysAgo"
 *       - in: query
 *         name: endDate
 *         schema:
 *           type: string
 *         default: "today"
 *       - in: query
 *         name: isMobileApp
 *         schema:
 *           type: boolean
 *         default: true
 *         description: True for screen name flow, false for previousPagePath -> pagePath web flow
 *     responses:
 *       200:
 *         description: User flow data fetched successfully
 *       500:
 *         description: Error fetching user flow data
 *   post:
 *     summary: Fetch GA4 User Flow / Page Transition Journey Data (POST)
 *     tags: [Analytics]
 *     requestBody:
 *       required: false
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               propertyId:
 *                 type: string
 *                 example: "455992850"
 *               startDate:
 *                 type: string
 *                 example: "30daysAgo"
 *               endDate:
 *                 type: string
 *                 example: "today"
 *               isMobileApp:
 *                 type: boolean
 *                 example: true
 *     responses:
 *       200:
 *         description: User flow data fetched successfully
 *       500:
 *         description: Error fetching user flow data
 */
router.get("/user-flow", getUserFlowReport);
router.post("/user-flow", getUserFlowReport);

/**
 * @openapi
 * /analytics/report:
 *   get:
 *     summary: Fetch GA4 Analytics Report (GET)
 *     tags: [Analytics]
 *     parameters:
 *       - in: query
 *         name: propertyId
 *         schema:
 *           type: string
 *         default: "455992850"
 *         description: GA4 Property ID
 *       - in: query
 *         name: startDate
 *         schema:
 *           type: string
 *         default: "7daysAgo"
 *         description: Start date (e.g. 7daysAgo, 30daysAgo, YYYY-MM-DD)
 *       - in: query
 *         name: endDate
 *         schema:
 *           type: string
 *         default: "today"
 *         description: End date (e.g. today, YYYY-MM-DD)
 *       - in: query
 *         name: dimensions
 *         schema:
 *           type: string
 *         default: "eventName"
 *         description: Comma-separated dimension names
 *       - in: query
 *         name: metrics
 *         schema:
 *           type: string
 *         default: "eventCount"
 *         description: Comma-separated metric names
 *     responses:
 *       200:
 *         description: GA4 Analytics Report fetched successfully
 *       500:
 *         description: Error fetching GA4 Analytics Report
 *   post:
 *     summary: Fetch GA4 Analytics Report (POST)
 *     tags: [Analytics]
 *     requestBody:
 *       required: false
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               propertyId:
 *                 type: string
 *                 example: "455992850"
 *               startDate:
 *                 type: string
 *                 example: "7daysAgo"
 *               endDate:
 *                 type: string
 *                 example: "today"
 *               dimensions:
 *                 type: array
 *                 items:
 *                   type: string
 *                 example: ["eventName"]
 *               metrics:
 *                 type: array
 *                 items:
 *                   type: string
 *                 example: ["eventCount"]
 *     responses:
 *       200:
 *         description: GA4 Analytics Report fetched successfully
 *       500:
 *         description: Error fetching GA4 Analytics Report
 */
router.get("/report", getGa4Report);
router.post("/report", getGa4Report);

export default router;
