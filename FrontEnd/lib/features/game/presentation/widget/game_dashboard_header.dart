import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:dbnus/shared/constants/assects_const.dart';
import 'package:dbnus/shared/ui/atoms/images/custom_image.dart';
import 'package:material_ui/material_ui.dart';

class GameDashboardHeader extends StatelessWidget {
  const GameDashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    final cardBg = isDark ? const Color(0xFF131520) : Colors.white;
    final accentColor = const Color(0xFF6C63FF); // Violet accent for Game Center

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(isDark ? 0.15 : 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: CustomSvgAssetImageView(
              path: AssetsConst.featherZap,
              color: accentColor,
              height: 22,
              width: 22,
            ),
          ),
          16.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  'Game Center',
                  color: isDark ? const Color(0xFFF8FAFC) : ColorConst.primaryDark,
                  fontWeight: FontWeight.w700,
                  size: 18,
                ),
                4.ph,
                CustomText(
                  'Choose a game and test your skills!',
                  color: isDark ? const Color(0xFF94A3B8) : ColorConst.secondaryDark,
                  size: 13,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(isDark ? 0.15 : 0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: accentColor.withOpacity(isDark ? 0.3 : 0.15)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomSvgAssetImageView(
                  path: AssetsConst.featherGrid,
                  color: accentColor,
                  height: 12,
                  width: 12,
                ),
                6.pw,
                CustomText(
                  '8', // updated from 6 since there are 8 games in the grid
                  color: accentColor,
                  fontWeight: FontWeight.w700,
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
