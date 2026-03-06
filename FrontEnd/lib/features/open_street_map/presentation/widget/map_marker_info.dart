import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/map_marker.dart';

class MapMarkerInfo extends StatelessWidget {
  final MapMarker marker;
  final VoidCallback? onClose;

  const MapMarkerInfo({
    super.key,
    required this.marker,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D2E),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: marker.color.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: marker.color.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: marker.color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(marker.icon, color: marker.color, size: 22),
              ),
              12.pw,
              Expanded(
                child: CustomText(
                  marker.name,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  size: 18,
                ),
              ),
              if (onClose != null)
                GestureDetector(
                  onTap: onClose,
                  child: const Icon(FeatherIcons.x,
                      color: Colors.white54, size: 20),
                ),
            ],
          ),
          12.ph,
          CustomText(
            marker.description,
            color: Colors.white70,
            size: 14,
          ),
          10.ph,
          Row(
            children: [
              const Icon(FeatherIcons.mapPin, color: Colors.white38, size: 14),
              6.pw,
              CustomText(
                '${marker.position.latitude.toStringAsFixed(4)}, '
                '${marker.position.longitude.toStringAsFixed(4)}',
                color: Colors.white38,
                size: 12,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
