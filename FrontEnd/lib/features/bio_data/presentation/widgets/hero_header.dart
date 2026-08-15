import 'package:dbnus/shared/constants/assects_const.dart';
import 'package:dbnus/shared/ui/atoms/images/custom_image.dart';
import 'package:material_ui/material_ui.dart';
import 'package:share_plus/share_plus.dart';

import 'package:dbnus/core/services/open_service.dart';
import 'package:dbnus/navigation/custom_router/custom_route.dart';
import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/ui/atoms/buttons/custom_button.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';

class HeroHeader extends StatelessWidget {
  const HeroHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Theme-specific colors
    final List<Color> bgColors = isDark 
        ? [ColorConst.sidebarBg, const Color(0xFF2D3250)]
        : [const Color(0xFFF8FAFC), const Color(0xFFE2E8F0)];
        
    final Color textColor = isDark ? Colors.white : ColorConst.primaryDark;
    final Color subTextColor = isDark ? Colors.white70 : ColorConst.secondaryDark;
    final Color iconColor = isDark ? Colors.white : ColorConst.primaryDark;
    
    final Color badgeBg = isDark 
        ? Colors.white.withOpacity(0.12)
        : Colors.black.withOpacity(0.05);
        
    final Color borderColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFCBD5E1);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 20,
        right: 20,
        bottom: 28,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: bgColors,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        border: Border(
          bottom: BorderSide(color: borderColor),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.2) : Colors.black.withOpacity(0.015),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top bar
          Row(
            children: [
              CustomIconButton(
                icon: CustomSvgAssetImageView(
                  path: AssetsConst.featherArrowLeft,
                  color: iconColor,
                ),
                color: iconColor,
                iconSize: 20,
                onPressed: () => CustomRoute.back(),
              ),
              const Spacer(),
              CustomIconButton(
                icon: CustomSvgAssetImageView(
                  path: AssetsConst.featherShare2,
                  color: iconColor.withOpacity(0.8),
                ),
                color: iconColor.withOpacity(0.8),
                iconSize: 20,
                onPressed: () {
                  OpenService.share(
                    shareParams: ShareParams(
                      uri: Uri.parse("https://dbnus-df986.web.app/bio-data"),
                      title: "Arijit Sarkar - Flutter Developer",
                    ),
                  );
                },
              ),
            ],
          ),
          16.ph,

          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  ColorConst.sidebarSelected,
                  ColorConst.violate,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: ColorConst.sidebarSelected.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: CustomText(
                "AS",
                color: Colors.white,
                size: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          12.ph,

          // Name
          CustomText(
            "Arijit Sarkar",
            color: textColor,
            size: 22,
            fontWeight: FontWeight.w800,
          ),
          6.ph,

          // Role badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomSvgAssetImageView(
                  path: AssetsConst.featherCode,
                  height: 12,
                  width: 12,
                  color: subTextColor,
                ),
                8.pw,
                CustomText(
                  "Flutter Developer  •  4+ Years",
                  color: subTextColor,
                  size: 11,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
