// src/index.ts
import "dotenv/config";
import http from "http";
import app from "./app.js";
import { initSocket } from "./config/socket.js";
import { CustomConsole } from "./utils/custom_console.js";

const server = http.createServer(app);

// Initialize Socket.io
initSocket(server);

/*
 * Get the value of the PORT environment variable
 * from the `process.env` and start listening
 */
const port = process.env.PORT || 3000;

server.listen(port, () => {
  CustomConsole.infoLog(`Server is running at http://localhost:${port}`, { tag: "server" });
});