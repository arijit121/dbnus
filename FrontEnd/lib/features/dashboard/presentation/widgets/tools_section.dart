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
import 'package:dbnus/navigation/custom_router/custom_route.dart';
import 'package:dbnus/navigation/router_name.dart';

class ToolsSection extends StatelessWidget {
  const ToolsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tools = [
      _ToolItem(
        icon: FeatherIcons.download,
        title: "Download GlucoseFasting PDF",
        subtitle: "Download sample report",
        color: ColorConst.deepGreen,
        tag: "Download",
        onTap: () {
          DownloadHandler.download(
              downloadUrl:
                  "https://res.genupathlabs.com/genu_path_lab/live/customer_V2/sample_report/GlucoseFasting.pdf");
        },
      ),
      _ToolItem(
        icon: FeatherIcons.downloadCloud,
        title: "Download with Headers",
        subtitle: "Authenticated download",
        color: ColorConst.lightBlue,
        tag: "Download",
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
      _ToolItem(
        icon: FeatherIcons.mapPin,
        title: "Forward Geocoding",
        subtitle: "Jot Bhim, New Town, Bidhannagar",
        color: ColorConst.violate,
        tag: "Location",
        onTap: () async {
          ForwardGeocoding? forwardGeocoding =
              await Geocoding.forwardGeocoding(
                  address:
                      "Jot Bhim, New Town, Bidhannagar, North 24 Parganas District, West Bengal, 700160, India");
          AppLog.i(forwardGeocoding?.longitude);
        },
      ),
      _ToolItem(
        icon: FeatherIcons.navigation,
        title: "Reverse Geocoding",
        subtitle: "Lat: 22.5754, Lng: 88.4798",
        color: const Color(0xFFE67E22),
        tag: "Location",
        onTap: () async {
          ReverseGeocoding? reverseGeocoding =
              await Geocoding.reverseGeocoding(
                  latitude: 22.5754, longitude: 88.4798);
          AppLog.i(reverseGeocoding?.displayName);
        },
      ),
      _ToolItem(
        icon: FeatherIcons.checkCircle,
        title: "Show Success Dialog",
        subtitle: "Display success message popup",
        color: ColorConst.green,
        tag: "UI",
        onTap: () {
          PopUpItems.customMsgDialog(
              title: "Success",
              content: "Thank you, transaction complete.",
              type: DialogType.success);
        },
      ),
      _ToolItem(
        icon: FeatherIcons.map,
        title: "Open Street Map",
        subtitle: "Explore world landmarks on a map",
        color: const Color(0xFF2980B9),
        tag: "Map",
        onTap: () {
          CustomRoute.navigateNamed(RouteName.openStreetMap);
        },
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: ColorConst.cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.04),
        ),
      ),
      child: Column(
        children: [
          // Header row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: ColorConst.violate.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(FeatherIcons.layers,
                      color: ColorConst.violate, size: 14),
                ),
                8.pw,
                CustomText(
                  "${tools.length} tools available",
                  size: 12,
                  color: ColorConst.secondaryDark,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: ColorConst.lineGrey),

          // Tool tiles
          ...List.generate(tools.length * 2 - 1, (index) {
            if (index.isOdd) {
              return const Divider(
                  height: 1, indent: 60, color: ColorConst.lineGrey);
            }
            return _buildToolTile(tools[index ~/ 2]);
          }),
        ],
      ),
    );
  }

  Widget _buildToolTile(_ToolItem tool) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: tool.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Ring-bordered icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: tool.color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: tool.color.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                ),
                child: Icon(tool.icon, color: tool.color, size: 20),
              ),
              14.pw,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: CustomText(
                            tool.title,
                            fontWeight: FontWeight.w600,
                            size: 14,
                            color: ColorConst.primaryDark,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        6.pw,
                        // Category tag
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: tool.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: CustomText(
                            tool.tag,
                            size: 10,
                            color: tool.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    3.ph,
                    CustomText(
                      tool.subtitle,
                      size: 12,
                      color: ColorConst.secondaryDark,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              8.pw,
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: ColorConst.lineGrey,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(FeatherIcons.chevronRight,
                    color: ColorConst.secondaryDark, size: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToolItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final String tag;
  final VoidCallback onTap;

  const _ToolItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.tag,
    required this.onTap,
  });
}
