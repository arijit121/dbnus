import { Response } from "express";

/**
 * Standardizes API responses across the backend application.
 * 
 * @param res - Express Response object
 * @param statusCode - HTTP status code
 * @param data - The payload or error details to send (object, array, string, etc.)
 * @param message - An optional descriptive message summarizing the result
 */
export const sendResponse = (
  res: Response,
  statusCode: number,
  data: any = {},
  message: string = ""
) => {
  return res.status(statusCode).json({
    status_code: statusCode,
    data,
    message,
  });
};
