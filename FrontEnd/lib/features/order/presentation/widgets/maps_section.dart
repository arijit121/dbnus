import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';

import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/core/services/open_service.dart';

import 'order_tool_tile.dart';

class MapsSection extends StatelessWidget {
  const MapsSection({super.key});

  Widget _buildDivider() =>
      const Divider(height: 1, indent: 56, color: ColorConst.lineGrey);

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
          OrderToolTile(
            icon: FeatherIcons.search,
            title: "Open Kolkata in Maps",
            subtitle: "Search by address with directions",
            color: ColorConst.deepGreen,
            onTap: () {
              OpenService.openAddressInMap(address: 'Kolkata', direction: true);
            },
          ),
          _buildDivider(),
          OrderToolTile(
            icon: FeatherIcons.navigation,
            title: "Open Coordinates",
            subtitle: "Lat: 22.5354, Lng: 88.3474",
            color: ColorConst.lightBlue,
            onTap: () {
              OpenService.openCoordinatesInMap(
                latitude: 22.5354273,
                longitude: 88.3473527,
              );
            },
          ),
        ],
      ),
    );
  }
}
