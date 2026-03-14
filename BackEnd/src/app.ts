// src/app.ts
import express, { Express } from "express";
import routes from "./routes/index.js";
import { errorHandler } from "./middleware/error.handler.js";
import { setupSwagger } from "./config/swagger.js";

const app: Express = express();

// Middleware
app.use(express.json());

// Swagger Docs
setupSwagger(app);

// Routes
app.use(routes);

// Error handling
app.use(errorHandler);

export default app;
