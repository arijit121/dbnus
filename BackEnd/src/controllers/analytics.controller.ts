// src/controllers/analytics.controller.ts
import { Request, Response } from "express";
import { BetaAnalyticsDataClient } from "@google-analytics/data";
import { JWT } from "google-auth-library";
import fs from "fs";
import path from "path";
import { sendResponse } from "../utils/response.util.js";

// Helper function to resolve service account credentials
const getServiceAccountCredentials = () => {
  if (!process.env.FIREBASE_SERVICE_ACCOUNT) {
    throw new Error("Missing FIREBASE_SERVICE_ACCOUNT environment variable.");
  }

  const serviceAccountValue = process.env.FIREBASE_SERVICE_ACCOUNT.trim();
  let serviceAccountData: any;

  if (serviceAccountValue.startsWith("{")) {
    serviceAccountData = JSON.parse(serviceAccountValue);
  } else {
    const resolvedPath = path.resolve(process.cwd(), serviceAccountValue);
    serviceAccountData = JSON.parse(fs.readFileSync(resolvedPath, "utf8"));
  }

  const privateKey = serviceAccountData.private_key
    ? serviceAccountData.private_key.replace(/\\n/g, "\n")
    : undefined;

  return {
    projectId: serviceAccountData.project_id,
    clientEmail: serviceAccountData.client_email,
    privateKey: privateKey,
  };
};

const getAnalyticsClient = (): BetaAnalyticsDataClient => {
  const creds = getServiceAccountCredentials();
  return new BetaAnalyticsDataClient({
    credentials: {
      client_email: creds.clientEmail,
      private_key: creds.privateKey,
    },
    projectId: creds.projectId,
  });
};

const DEFAULT_PROPERTY_ID = "455992850";

/**
 * Endpoint to generate a short-lived OAuth 2.0 Access Token
 * scoped for Google Analytics API (https://www.googleapis.com/auth/analytics.readonly).
 */
export const getGa4AccessToken = async (req: Request, res: Response) => {
  try {
    const creds = getServiceAccountCredentials();

    const jwtClient = new JWT({
      email: creds.clientEmail,
      key: creds.privateKey,
      scopes: ["https://www.googleapis.com/auth/analytics.readonly"],
    });

    const tokens = await jwtClient.getAccessToken();

    return sendResponse(
      res,
      200,
      {
        access_token: tokens.token,
        token_type: "Bearer",
        scope: "https://www.googleapis.com/auth/analytics.readonly",
      },
      "Successfully generated GA4 access token"
    );
  } catch (error: any) {
    console.error("Error generating GA4 access token:", error);
    return sendResponse(
      res,
      500,
      { error: error?.message || `${error}` },
      "Failed to generate GA4 access token"
    );
  }
};

/**
 * Controller to fetch generic GA4 Analytics Report for a property using @google-analytics/data SDK
 */
export const getGa4Report = async (req: Request, res: Response) => {
  try {
    const propertyId = (req.body.propertyId || req.query.propertyId || DEFAULT_PROPERTY_ID) as string;
    const startDate = (req.body.startDate || req.query.startDate || "7daysAgo") as string;
    const endDate = (req.body.endDate || req.query.endDate || "today") as string;
    const limit = Number(req.body.limit || req.query.limit || 10000);
    const offset = Number(req.body.offset || req.query.offset || 0);

    // Handle string arrays or comma-separated parameters
    let dimensions: string[] = req.body.dimensions || req.query.dimensions;
    if (!dimensions) {
      dimensions = ["eventName"];
    } else if (typeof dimensions === "string") {
      dimensions = (dimensions as string).split(",").map((s) => s.trim());
    }

    let metrics: string[] = req.body.metrics || req.query.metrics;
    if (!metrics) {
      metrics = ["eventCount"];
    } else if (typeof metrics === "string") {
      metrics = (metrics as string).split(",").map((s) => s.trim());
    }

    const client = getAnalyticsClient();

    const [response] = await client.runReport({
      property: `properties/${propertyId}`,
      dateRanges: [
        {
          startDate,
          endDate,
        },
      ],
      dimensions: dimensions.map((name) => ({ name })),
      metrics: metrics.map((name) => ({ name })),
      limit,
      offset,
    });

    // Format response into developer & mobile friendly structure
    const dimensionHeaders = response.dimensionHeaders?.map((h) => h.name) || [];
    const metricHeaders = response.metricHeaders?.map((h) => h.name) || [];

    const rows = (response.rows || []).map((row) => {
      const rowData: Record<string, string> = {};

      row.dimensionValues?.forEach((val, idx) => {
        const headerName = dimensionHeaders[idx] || `dimension_${idx}`;
        rowData[headerName] = val.value || "";
      });

      row.metricValues?.forEach((val, idx) => {
        const headerName = metricHeaders[idx] || `metric_${idx}`;
        rowData[headerName] = val.value || "0";
      });

      return rowData;
    });

    return sendResponse(
      res,
      200,
      {
        propertyId,
        dateRange: { startDate, endDate },
        pagination: {
          limit,
          offset,
          totalRowsInGA4: response.rowCount || rows.length,
          returnedRows: rows.length,
        },
        data: rows,
        rawReport: response,
      },
      "Successfully fetched GA4 analytics report"
    );
  } catch (error: any) {
    console.error("Error fetching GA4 report:", error);
    return sendResponse(
      res,
      500,
      { error: error?.message || `${error}` },
      "Failed to fetch GA4 analytics report"
    );
  }
};

/**
 * Controller to fetch User Flow / Navigation Journey Data from GA4
 */
export const getUserFlowReport = async (req: Request, res: Response) => {
  try {
    const propertyId = (req.body.propertyId || req.query.propertyId || DEFAULT_PROPERTY_ID) as string;
    const startDate = (req.body.startDate || req.query.startDate || "30daysAgo") as string;
    const endDate = (req.body.endDate || req.query.endDate || "today") as string;
    const isMobileApp = (req.body.isMobileApp || req.query.isMobileApp || "true").toString() === "true";
    const limit = Number(req.body.limit || req.query.limit || 500);

    const dimensionNames = isMobileApp
      ? ["unifiedScreenName", "eventName"]
      : ["previousPagePath", "pagePath"];

    const metricNames = ["screenPageViews", "activeUsers", "eventCount"];

    const client = getAnalyticsClient();

    const [response] = await client.runReport({
      property: `properties/${propertyId}`,
      dateRanges: [
        {
          startDate,
          endDate,
        },
      ],
      dimensions: dimensionNames.map((name) => ({ name })),
      metrics: metricNames.map((name) => ({ name })),
      limit,
    });

    const userFlowData = (response.rows || []).map((row) => {
      const dim0 = row.dimensionValues?.[0]?.value || "(entrance)";
      const dim1 = row.dimensionValues?.[1]?.value || "(not set)";
      const views = row.metricValues?.[0]?.value || "0";
      const users = row.metricValues?.[1]?.value || "0";
      const events = row.metricValues?.[2]?.value || "0";

      if (isMobileApp) {
        return {
          screenName: dim0,
          eventName: dim1,
          screenViews: Number(views),
          activeUsers: Number(users),
          eventCount: Number(events),
        };
      } else {
        return {
          fromPage: dim0,
          toPage: dim1,
          pageViews: Number(views),
          activeUsers: Number(users),
          eventCount: Number(events),
        };
      }
    });

    return sendResponse(
      res,
      200,
      {
        propertyId,
        dateRange: { startDate, endDate },
        flowType: isMobileApp ? "Mobile Screen Flow" : "Web Page Transition Flow",
        totalSteps: userFlowData.length,
        userFlow: userFlowData,
      },
      "Successfully fetched GA4 user flow report"
    );
  } catch (error: any) {
    console.error("Error fetching user flow report:", error);
    return sendResponse(
      res,
      500,
      { error: error?.message || `${error}` },
      "Failed to fetch GA4 user flow report"
    );
  }
};

/**
 * Controller to fetch User-Centric & Detailed Event Analytics Data
 * 
 * Supports high-limit queries (up to 10,000 rows per call), pagination (limit & offset),
 * and custom date ranges (e.g. 365daysAgo or 2020-01-01).
 */
export const getUserSpecificReport = async (req: Request, res: Response) => {
  try {
    const propertyId = (req.body.propertyId || req.query.propertyId || DEFAULT_PROPERTY_ID) as string;
    const startDate = (req.body.startDate || req.query.startDate || "365daysAgo") as string; // Default to 365 days ago for full history
    const endDate = (req.body.endDate || req.query.endDate || "today") as string;

    const limit = Number(req.body.limit || req.query.limit || 10000); // Default to max 10,000 rows
    const offset = Number(req.body.offset || req.query.offset || 0);

    let userId = (req.body.userId || req.query.userId) as string | undefined;

    // Decode Base64 if passed as base64 (e.g. MTIxMTk0OQ== -> 1211949)
    let decodedUserId = userId;
    if (userId && /^[A-Za-z0-9+/=]+$/.test(userId) && userId.endsWith("==")) {
      try {
        decodedUserId = Buffer.from(userId, "base64").toString("utf-8");
      } catch (e) {
        decodedUserId = userId;
      }
    }

    const client = getAnalyticsClient();

    // Query Detailed Events with Screen Names, Event Names, Dates & Metrics
    const [response] = await client.runReport({
      property: `properties/${propertyId}`,
      dateRanges: [{ startDate, endDate }],
      dimensions: [
        { name: "signedInWithUserId" },
        { name: "eventName" },
        { name: "unifiedScreenName" },
        { name: "date" },
      ],
      metrics: [
        { name: "eventCount" },
        { name: "activeUsers" },
        { name: "userEngagementDuration" },
      ],
      dimensionFilter: userId
        ? {
            filter: {
              fieldName: "signedInWithUserId",
              stringFilter: {
                matchType: "EXACT" as const,
                value: "yes",
              },
            },
          }
        : undefined,
      limit,
      offset,
    });

    const detailedEvents = (response.rows || []).map((row) => {
      return {
        signedInStatus: row.dimensionValues?.[0]?.value || "(not set)",
        eventName: row.dimensionValues?.[1]?.value || "(not set)",
        screenName: row.dimensionValues?.[2]?.value || "(not set)",
        date: row.dimensionValues?.[3]?.value || "N/A",
        totalEvents: Number(row.metricValues?.[0]?.value || 0),
        activeUsers: Number(row.metricValues?.[1]?.value || 0),
        userEngagementDurationSeconds: Number(row.metricValues?.[2]?.value || 0),
      };
    });

    // Calculate Event Type Summary Totals across all returned rows
    const eventSummaryMap: Record<string, { totalEvents: number; activeUsers: number }> = {};
    detailedEvents.forEach((item) => {
      if (!eventSummaryMap[item.eventName]) {
        eventSummaryMap[item.eventName] = { totalEvents: 0, activeUsers: 0 };
      }
      eventSummaryMap[item.eventName].totalEvents += item.totalEvents;
      eventSummaryMap[item.eventName].activeUsers = Math.max(
        eventSummaryMap[item.eventName].activeUsers,
        item.activeUsers
      );
    });

    const eventSummary = Object.keys(eventSummaryMap).map((eventName) => ({
      eventName,
      totalEvents: eventSummaryMap[eventName].totalEvents,
      maxActiveUsers: eventSummaryMap[eventName].activeUsers,
    }));

    const totalGA4Rows = response.rowCount || detailedEvents.length;
    const hasMoreData = offset + detailedEvents.length < totalGA4Rows;

    return sendResponse(
      res,
      200,
      {
        propertyId,
        requestedUserId: userId,
        decodedUserId: decodedUserId !== userId ? decodedUserId : undefined,
        dateRange: { startDate, endDate },
        pagination: {
          limit,
          offset,
          totalRowsInGA4: totalGA4Rows,
          returnedRowsInPage: detailedEvents.length,
          hasMoreData,
          nextOffset: hasMoreData ? offset + limit : null,
        },
        eventSummary,
        detailedEvents,
      },
      "Successfully fetched complete GA4 user event analytics report"
    );
  } catch (error: any) {
    console.error("Error fetching user-specific report:", error);
    return sendResponse(
      res,
      500,
      { error: error?.message || `${error}` },
      "Failed to fetch user-specific GA4 analytics report"
    );
  }
};
