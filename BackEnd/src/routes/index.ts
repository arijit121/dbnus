// src/routes/index.ts
import { Router, Request, Response } from "express";
import fcmRoutes from "./fcm.routes.js";
import placesRoutes from "./places.routes.js";
import userRoutes from "./user.routes.js";

const router = Router();

// Root route
router.get("/", (req: Request, res: Response) => {
  res.send("Express + TypeScript Server");
});

// Feature routes
router.use(fcmRoutes);
router.use(placesRoutes);
router.use(userRoutes);

export default router;
