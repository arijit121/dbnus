// src/middleware/error.handler.ts
import { Request, Response, NextFunction } from "express";
import { CustomConsole } from "../utils/custom_console.js";

export const errorHandler = (
  err: Error,
  req: Request,
  res: Response,
  _next: NextFunction
) => {
  CustomConsole.errorLog(err.message, { tag: "error" });
  res.status(500).json({ error: "Internal Server Error" });
};
