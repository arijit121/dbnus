// src/controllers/user.controller.ts
import { Request, Response } from "express";
import prisma from "../config/prisma.js";
import { sendResponse } from "../utils/response.util.js";

// GET /users — list all users
export const getAllUsers = async (_req: Request, res: Response) => {
  try {
    const users = await prisma.user.findMany({
      orderBy: { createdAt: "desc" },
    });
    return sendResponse(res, 200, users, "Successfully fetched users");
  } catch (e) {
    return sendResponse(res, 500, { error: `${e}` }, "Failed to fetch users");
  }
};

// GET /users/:id — get user by ID
export const getUserById = async (req: Request, res: Response) => {
  try {
    const user = await prisma.user.findUnique({
      where: { id: req.params.id },
    });
    if (!user) {
      return sendResponse(res, 404, {}, "User not found");
    }
    return sendResponse(res, 200, user, "Successfully fetched user");
  } catch (e) {
    return sendResponse(res, 500, { error: `${e}` }, "Failed to fetch user");
  }
};

// POST /users — create a new user
export const createUser = async (req: Request, res: Response) => {
  try {
    const { email, name } = req.body;
    if (!email) {
      return sendResponse(res, 400, {}, "Email is required");
    }
    const user = await prisma.user.create({
      data: { email, name },
    });
    return sendResponse(res, 201, user, "Successfully created user");
  } catch (e) {
    return sendResponse(res, 500, { error: `${e}` }, "Failed to create user");
  }
};

// PUT /users/:id — update a user
export const updateUser = async (req: Request, res: Response) => {
  try {
    const { email, name } = req.body;
    const user = await prisma.user.update({
      where: { id: req.params.id },
      data: { ...(email && { email }), ...(name !== undefined && { name }) },
    });
    return sendResponse(res, 200, user, "Successfully updated user");
  } catch (e) {
    return sendResponse(res, 500, { error: `${e}` }, "Failed to update user");
  }
};

// DELETE /users/:id — delete a user
export const deleteUser = async (req: Request, res: Response) => {
  try {
    await prisma.user.delete({
      where: { id: req.params.id },
    });
    return sendResponse(res, 200, {}, "User deleted successfully");
  } catch (e) {
    return sendResponse(res, 500, { error: `${e}` }, "Failed to delete user");
  }
};
