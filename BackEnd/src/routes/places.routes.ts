// src/routes/places.routes.ts
import { Router } from "express";
import { getAutocomplete } from "../controllers/places.controller.js";

const router = Router();

/**
 * @openapi
 * /places/autocomplete:
 *   get:
 *     summary: Get Google Places autocomplete suggestions
 *     tags: [Places]
 *     parameters:
 *       - in: query
 *         name: input
 *         schema:
 *           type: string
 *         required: true
 *         description: The search string to autocomplete
 *     responses:
 *       200:
 *         description: Autocomplete suggestions retrieved successfully
 *       400:
 *         description: Missing input parameter
 *       500:
 *         description: Server error or Google API error
 */
router.get("/autocomplete", getAutocomplete);

export default router;
