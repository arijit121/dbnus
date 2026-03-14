// src/routes/index.ts
import { Router } from "express";
import express from "express";
import path from "path";
import fcmRoutes from "./fcm.routes.js";
import placesRoutes from "./places.routes.js";
import userRoutes from "./user.routes.js";
import uploadRoutes from "./upload.routes.js";

const router = Router();

// API Routes
router.use("/user", userRoutes);
router.use("/places", placesRoutes);
router.use("/fcm", fcmRoutes);
router.use("/upload", uploadRoutes); // Mount upload routes

// Serve uploaded files statically
router.use("/uploads", express.static(path.join(__dirname, "../../uploads")));

export default router;
