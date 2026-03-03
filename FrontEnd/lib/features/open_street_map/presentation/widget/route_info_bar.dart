import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

class RouteInfoBar extends StatelessWidget {
  final double distanceKm;
  final double durationMinutes;
  final VoidCallback onClose;

  const RouteInfoBar({
    super.key,
    required this.distanceKm,
    required this.durationMinutes,
    required this.onClose,
  });

  String _formatDistance() {
    if (distanceKm < 1) {
      return '${(distanceKm * 1000).round()} m';
    }
    return '${distanceKm.toStringAsFixed(1)} km';
  }

  String _formatDuration() {
    final totalMin = durationMinutes.round();
    if (totalMin < 60) return '$totalMin min';
    final hours = totalMin ~/ 60;
    final mins = totalMin % 60;
    return '${hours}h ${mins}m';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF34A853).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(FeatherIcons.navigation,
                color: Color(0xFF34A853), size: 18),
          ),
          12.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  _formatDuration(),
                  color: const Color(0xFF34A853),
                  fontWeight: FontWeight.w700,
                  size: 16,
                ),
                2.ph,
                CustomText(
                  _formatDistance(),
                  color: const Color(0xFF5F6368),
                  size: 13,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3F4),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(FeatherIcons.truck, size: 14, color: Color(0xFF5F6368)),
              ],
            ),
          ),
          8.pw,
          GestureDetector(
            onTap: onClose,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F3F4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(FeatherIcons.x,
                  size: 16, color: Color(0xFF5F6368)),
            ),
          ),
        ],
      ),
    );
  }
}
