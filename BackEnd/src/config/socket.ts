import { Server } from "socket.io";
import { Server as HttpServer } from "http";
import { CustomConsole } from "../utils/custom_console.js";

let io: Server;

export const initSocket = (server: HttpServer) => {
  io = new Server(server, {
    cors: {
      origin: "*", // Adjust for production
      methods: ["GET", "POST"]
    }
  });

  io.on("connection", (socket) => {
    CustomConsole.infoLog(`Client connected via socket: ${socket.id}`, { tag: "socket" });

    socket.on("disconnect", () => {
      CustomConsole.infoLog(`Client disconnected: ${socket.id}`, { tag: "socket" });
    });
  });

  return io;
};

export const getIO = () => {
  if (!io) {
    throw new Error("Socket.io not initialized!");
  }
  return io;
};
