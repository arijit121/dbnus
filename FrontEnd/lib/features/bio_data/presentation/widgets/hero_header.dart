import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
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
          colors: [
            ColorConst.sidebarBg,
            const Color(0xFF2D3250),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: ColorConst.sidebarBg.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top bar
          Row(
            children: [
              CustomIconButton(
                icon: const Icon(FeatherIcons.arrowLeft),
                color: Colors.white,
                iconSize: 20,
                onPressed: () => CustomRoute.back(),
              ),
              const Spacer(),
              CustomIconButton(
                icon: const Icon(FeatherIcons.share2),
                color: Colors.white70,
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
                  color: ColorConst.sidebarSelected.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Center(
              child: CustomText(
                "AS",
                color: Colors.white,
                size: 30,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          12.ph,

          // Name
          const CustomText(
            "Arijit Sarkar",
            color: Colors.white,
            size: 24,
            fontWeight: FontWeight.w800,
          ),
          6.ph,

          // Role badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(FeatherIcons.code, size: 14, color: Colors.white70),
                8.pw,
                const CustomText(
                  "Flutter Developer  •  4+ Years",
                  color: Colors.white70,
                  size: 12,
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
