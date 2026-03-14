import multer from "multer";
import path from "path";

// Configure local storage for uploaded files
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    // Save files directly to the root 'uploads' folder
    cb(null, "uploads/");
  },
  filename: (req, file, cb) => {
    // Generate a unique identifier prepended to the original extension
    const uniqueSuffix = Date.now() + "-" + Math.round(Math.random() * 1e9);
    const ext = path.extname(file.originalname);
    cb(null, `${file.fieldname}-${uniqueSuffix}${ext}`);
  },
});

// Create Multer instance with the storage configuration
export const upload = multer({
  storage,
  limits: {
    fileSize: 10 * 1024 * 1024, // 10 MB file size limit
  },
});
