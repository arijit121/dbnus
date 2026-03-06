import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

class GameDashboardHeader extends StatelessWidget {
  const GameDashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1D2E), Color(0xFF2D3250)],
        ),
        boxShadow: [
          BoxShadow(
            color: ColorConst.sidebarBg.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(FeatherIcons.zap, color: Colors.white, size: 26),
          ),
          16.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  'Game Center',
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  size: 22,
                ),
                4.ph,
                CustomText(
                  'Choose a game and have fun!',
                  color: Colors.white.withValues(alpha: 0.7),
                  size: 13,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FF).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: const Color(0xFF6C63FF).withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(FeatherIcons.grid,
                    color: Color(0xFF6C63FF), size: 14),
                6.pw,
                const CustomText('6',
                    color: Color(0xFF6C63FF),
                    fontWeight: FontWeight.w700,
                    size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
