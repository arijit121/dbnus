import { PrismaClient } from "../../prisma/generated/client.js";

// Singleton pattern — reuse the same client across the app
const prisma = new PrismaClient();

export default prisma;
