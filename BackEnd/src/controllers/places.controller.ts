// src/controllers/places.controller.ts
import { Request, Response } from "express";
import axios from "axios";
import { sendResponse } from "../utils/response.util.js";

export const getAutocomplete = async (req: Request, res: Response) => {
  const { input, country } = req.query;

  if (!input) {
    return sendResponse(res, 400, {}, "Missing 'input' query parameter");
  }

  try {
    const params = new URLSearchParams({
      input: input as string,
      key: "AIzaSyCgpehkvboNjg0FX_f7OjLczZ-SxwtvXYk",
      ...(country ? { components: `country:${country}` } : {}),
    });

    const { data } = await axios.get(`https://maps.googleapis.com/maps/api/place/autocomplete/json?${params.toString()}`);
    return sendResponse(res, 200, data, "Successfully fetched autocomplete predictions");
  } catch (err) {
    console.error("Error fetching autocomplete:", err);
    return sendResponse(res, 500, {}, "Failed to fetch from Google Places API");
  }
};
