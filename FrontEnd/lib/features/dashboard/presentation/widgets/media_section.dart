import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:feather_icons/feather_icons.dart';

import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/constants/api_url_const.dart';
import 'package:dbnus/shared/utils/screen_utils.dart';
import 'package:dbnus/shared/utils/pop_up_items.dart';
import 'package:dbnus/shared/ui/atoms/images/custom_image.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:dbnus/shared/ui/organisms/carousels/carousel_slider.dart';
import 'package:dbnus/shared/ui/organisms/video/youtube_video_player.dart';
import 'package:dbnus/navigation/router_name.dart';

import '../../../../shared/ui/organisms/video/youtube_webview_flutter_player.dart';
import '../../../../shared/ui/organisms/video/youtube_inappwebview_player.dart';

class MediaSection extends StatelessWidget {
  const MediaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── YouTube Player ──────────────────────────
        _MediaCard(
          label: "Featured Video",
          icon: FeatherIcons.youtube,
          child: Stack(
            children: [
              const YoutubeInAppWebviewPlayer(
                videoUrl: "https://www.youtube.com/watch?v=CIfLE0CShbg",
                height: 220,
              ),
              // Play button overlay
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.3),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        20.ph,

        // ── Image Pair: Gallery ─────────────────────
        Row(
          spacing: 12,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: _ImageCardWithOverlay(
                url: ApiUrlConst.testImgUrl(),
                height: 180,
                label: "Gallery",
                onTap: () {
                  PopUpItems.toastMessage("On Tap", ColorConst.baseHexColor);
                },
              ),
            ),
            Expanded(
              child: _ImageCardWithOverlay(
                url: "${ApiUrlConst.testImgUrl()}lfmbldmfbl",
                height: 180,
                label: "Explore",
              ),
            ),
          ],
        ),
        20.ph,

        // ── Featured Carousel ───────────────────────
        _MediaCard(
          label: "Featured Collection",
          icon: FeatherIcons.grid,
          child: CarouselSlider(
            radius: 14,
            autoScrollDuration: const Duration(seconds: 4),
            imageList: List.generate(5, (int index) {
              return index == 2
                  ? ApiUrlConst.testImgUrl(aspectRatio: 16 / 9)
                  : ApiUrlConst.testImgUrl();
            }),
            onTap: (index) {
              kIsWeb
                  ? context.goNamed(RouteName.games)
                  : context.pushNamed(RouteName.games);
            },
            height: 400,
          ),
        ),
        20.ph,

        // ── Image pair: Showcase ────────────────────
        Row(
          spacing: 12,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: _ImageCardWithOverlay(
                url: ApiUrlConst.testImgUrl(),
                height: ScreenUtils.nw() / 2,
                label: "Showcase",
              ),
            ),
            Expanded(
              child: _ImageCardWithOverlay(
                url: ApiUrlConst.testImgUrl(),
                height: ScreenUtils.nw() / 2,
                label: "Discover",
              ),
            ),
          ],
        ),
        20.ph,

        // ── Small image pair ────────────────────────
        Row(
          spacing: 12,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: _ImageCardWithOverlay(
                url: ApiUrlConst.testImgUrl(),
                height: 100,
                label: "Trending",
              ),
            ),
            Expanded(
              child: _ImageCardWithOverlay(
                url:
                    "https://stage-cdn.aadharhealth.in/incom/app_images/1726653030_accessories.png",
                height: 100,
                label: "Accessories",
              ),
            ),
          ],
        ),
        20.ph,

        // ── Second Carousel ─────────────────────────
        _MediaCard(
          label: "More to Explore",
          icon: FeatherIcons.compass,
          child: CarouselSlider(
            radius: 14,
            autoScrollDuration: const Duration(seconds: 4),
            imageList: List.generate(5, (int index) {
              return index == 2
                  ? ApiUrlConst.testImgUrl(aspectRatio: 16 / 9)
                  : ApiUrlConst.testImgUrl();
            }),
            onTap: (index) {
              kIsWeb
                  ? context.goNamed(RouteName.games)
                  : context.pushNamed(RouteName.games);
            },
            height: 400,
          ),
        ),
        20.ph,

        // ── Final image pair ────────────────────────
        Row(
          spacing: 12,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: _ImageCardWithOverlay(
                url: ApiUrlConst.testImgUrl(),
                height: ScreenUtils.nw() / 2,
                label: "Inspire",
              ),
            ),
            Expanded(
              child: _ImageCardWithOverlay(
                url: ApiUrlConst.testImgUrl(),
                height: ScreenUtils.nw() / 2,
                label: "Create",
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// A media card wrapper with rounded corners, shadow, and optional label header.
class _MediaCard extends StatelessWidget {
  const _MediaCard({
    required this.child,
    this.label,
    this.icon,
  });

  final Widget child;
  final String? label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorConst.cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.04),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 14, color: ColorConst.secondaryDark),
                    6.pw,
                  ],
                  CustomText(
                    label!,
                    size: 12,
                    color: ColorConst.secondaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: label != null ? Radius.zero : const Radius.circular(18),
              bottom: const Radius.circular(18),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

/// An image card with gradient overlay and label at the bottom.
class _ImageCardWithOverlay extends StatelessWidget {
  const _ImageCardWithOverlay({
    required this.url,
    required this.height,
    this.label,
    this.onTap,
  });

  final String url;
  final double height;
  final String? label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                CustomNetWorkImageView(
                  url: url,
                  radius: 16,
                  height: height,
                  fit: BoxFit.cover,
                ),
                // Gradient overlay
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.5),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),
                // Label
                if (label != null)
                  Positioned(
                    left: 12,
                    bottom: 10,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CustomText(
                            label!,
                            color: Colors.white,
                            size: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
