import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';

import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';

class LeaderboardHeader extends StatelessWidget {
  const LeaderboardHeader({super.key});

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
          colors: [
            Color(0xFF1B7A4D),
            ColorConst.deepGreen,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: ColorConst.deepGreen.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                const Icon(FeatherIcons.award, color: Colors.white, size: 24),
          ),
          16.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  "Leaderboard",
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  size: 22,
                ),
                4.ph,
                const CustomText(
                  "Drag to reorder items",
                  color: Colors.white70,
                  size: 13,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
