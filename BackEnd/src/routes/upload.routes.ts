import { Request, Response, Router } from "express";
import { upload } from "../middleware/upload.js";
import { sendResponse } from "../utils/response.util.js";

const uploadRouter = Router();

// Handle file upload
uploadRouter.post("/", upload.single("file"), (req: Request, res: Response) => {
  try {
    if (!req.file) {
      return sendResponse(res, 400, {}, "No file uploaded.");
    }

    const fileData = {
      filename: req.file.filename,
      originalName: req.file.originalname,
      mimeType: req.file.mimetype,
      size: req.file.size,
      path: `uploads/${req.file.filename}`, // Relative path for access later
    };

    return sendResponse(res, 201, fileData, "File uploaded successfully");
  } catch (error) {
    return sendResponse(res, 500, { error: `${error}` }, "File upload failed");
  }
});

export default uploadRouter;
