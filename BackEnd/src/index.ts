// src/index.ts
import dotenv from "dotenv";
import app from "./app.js";
import { CustomConsole } from "./utils/custom_console.js";

/*
 * Load up and parse configuration details from
 * the `.env` file to the `process.env`
 * object of Node.js
 */
dotenv.config();

/*
 * Get the value of the PORT environment variable
 * from the `process.env` and start listening
 */
const port = process.env.PORT || 3000;

app.listen(port, () => {
  CustomConsole.infoLog(`Server is running at http://localhost:${port}`, { tag: "server" });
});