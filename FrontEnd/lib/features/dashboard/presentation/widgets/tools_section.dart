import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';

import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:dbnus/shared/utils/pop_up_items.dart';
import 'package:dbnus/shared/extensions/logger_extension.dart';
import 'package:dbnus/core/services/download_handler.dart';
import 'package:dbnus/core/services/geocoding.dart';
import 'package:dbnus/core/services/models/forward_geocoding.dart';
import 'package:dbnus/core/services/models/reverse_geocoding.dart';

class ToolsSection extends StatelessWidget {
  const ToolsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorConst.cardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildToolTile(
            icon: FeatherIcons.download,
            title: "Download GlucoseFasting PDF",
            subtitle: "Download sample report",
            color: ColorConst.deepGreen,
            onTap: () {
              DownloadHandler.download(
                  downloadUrl:
                      "https://res.genupathlabs.com/genu_path_lab/live/customer_V2/sample_report/GlucoseFasting.pdf");
            },
          ),
          const Divider(height: 1, indent: 56, color: ColorConst.lineGrey),
          _buildToolTile(
            icon: FeatherIcons.downloadCloud,
            title: "Download with Headers",
            subtitle: "Authenticated download",
            color: ColorConst.lightBlue,
            onTap: () {
              DownloadHandler.download(
                  downloadUrl:
                      "http://65.0.139.63:5001/api/admin/invoices/676f20131e1add0f4b4b2a58/pdf",
                  headers: {
                    "Authentication":
                        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3N2FkM2Y3ZWQxZmQxZDA2YjgyMTliYiIsImlhdCI6MTczNjEwMjkwM30.RtRG7Sr6sPjCJX26Otmd9SWWfzF67_8ZzUIiblbJRZ8",
                    "App-Type": "A",
                    "App-Version": "1.0.0",
                    "Content-Type": "application/json",
                    "Device-Id": "7f9bfffbb6adeb27",
                    "Device-Density-Type": "xhdpi",
                    "Device-Name": "V2217A",
                    "Network-Info": "wifi",
                    "Device-Width": "431.30434782608694",
                    "Device-Os-Info": "9",
                    "Device-Height": "834.7826086956521",
                    "Device-Density": "560",
                    "App-Version-Code": "1"
                  });
            },
          ),
          const Divider(height: 1, indent: 56, color: ColorConst.lineGrey),
          _buildToolTile(
            icon: FeatherIcons.mapPin,
            title: "Forward Geocoding",
            subtitle: "Jot Bhim, New Town, Bidhannagar",
            color: ColorConst.violate,
            onTap: () async {
              ForwardGeocoding? forwardGeocoding = await Geocoding.forwardGeocoding(
                  address:
                      "Jot Bhim, New Town, Bidhannagar, North 24 Parganas District, West Bengal, 700160, India");
              AppLog.i(forwardGeocoding?.longitude);
            },
          ),
          const Divider(height: 1, indent: 56, color: ColorConst.lineGrey),
          _buildToolTile(
            icon: FeatherIcons.navigation,
            title: "Reverse Geocoding",
            subtitle: "Lat: 22.5754, Lng: 88.4798",
            color: const Color(0xFFE67E22),
            onTap: () async {
              ReverseGeocoding? reverseGeocoding =
                  await Geocoding.reverseGeocoding(
                      latitude: 22.5754, longitude: 88.4798);
              AppLog.i(reverseGeocoding?.displayName);
            },
          ),
          const Divider(height: 1, indent: 56, color: ColorConst.lineGrey),
          _buildToolTile(
            icon: FeatherIcons.checkCircle,
            title: "Show Success Dialog",
            subtitle: "Display success message popup",
            color: ColorConst.green,
            onTap: () {
              PopUpItems.customMsgDialog(
                  title: "Success",
                  content: "Thank you, transaction complete.",
                  type: DialogType.success);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildToolTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              14.pw,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      title,
                      fontWeight: FontWeight.w600,
                      size: 14,
                      color: ColorConst.primaryDark,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    2.ph,
                    CustomText(
                      subtitle,
                      size: 12,
                      color: ColorConst.secondaryDark,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(FeatherIcons.chevronRight,
                  color: ColorConst.grey, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
