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
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status_code:
 *                   type: integer
 *                   example: 200
 *                 data:
 *                   type: array
 *                   items:
 *                     type: object
 *                     properties:
 *                       description:
 *                         type: string
 *                         example: "New York, NY, USA"
 *                       place_id:
 *                         type: string
 *                         example: "ChIJOwg_06VPwokRYv534QaPC8g"
 *                 message:
 *                   type: string
 *                   example: "Successfully fetched autocomplete suggestions"
 *       400:
 *         description: Missing input parameter
 *       500:
 *         description: Server error or Google API error
 */
router.get("/autocomplete", getAutocomplete);

export default router;
