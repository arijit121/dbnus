import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/constants/api_url_const.dart';
import 'package:dbnus/shared/utils/screen_utils.dart';
import 'package:dbnus/shared/utils/pop_up_items.dart';
import 'package:dbnus/shared/ui/atoms/images/custom_image.dart';
import 'package:dbnus/shared/ui/organisms/carousels/carousel_slider.dart';
import 'package:dbnus/shared/ui/organisms/video/youtube_video_player.dart';
import 'package:dbnus/navigation/router_name.dart';

class MediaSection extends StatelessWidget {
  const MediaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // YouTube
        Container(
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
          clipBehavior: Clip.antiAlias,
          child: const YoutubeVideoPlayer(
            videoUrl: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
            height: 220,
          ),
        ),
        20.ph,

        // Image row
        Row(
          spacing: 12,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  PopUpItems.toastMessage("On Tap", ColorConst.baseHexColor);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: CustomNetWorkImageView(
                    url: ApiUrlConst.testImgUrl(),
                    radius: 14,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CustomNetWorkImageView(
                  url: "${ApiUrlConst.testImgUrl()}lfmbldmfbl",
                  radius: 14,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
        20.ph,

        // Carousel
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
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

        // Image pairs
        Row(
          spacing: 12,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CustomNetWorkImageView(
                  url: ApiUrlConst.testImgUrl(),
                  radius: 14,
                  height: ScreenUtils.nw() / 2,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CustomNetWorkImageView(
                  url: ApiUrlConst.testImgUrl(),
                  radius: 14,
                  height: ScreenUtils.nw() / 2,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
        20.ph,

        Row(
          spacing: 12,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CustomNetWorkImageView(
                  url: ApiUrlConst.testImgUrl(),
                  radius: 14,
                  height: 100,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CustomNetWorkImageView(
                  url:
                      "https://stage-cdn.aadharhealth.in/incom/app_images/1726653030_accessories.png",
                  radius: 14,
                  height: 100,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
        20.ph,

        // More carousels and images
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
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
        Row(
          spacing: 12,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CustomNetWorkImageView(
                  url: ApiUrlConst.testImgUrl(),
                  radius: 14,
                  height: ScreenUtils.nw() / 2,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CustomNetWorkImageView(
                  url: ApiUrlConst.testImgUrl(),
                  radius: 14,
                  height: ScreenUtils.nw() / 2,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
        20.ph,
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
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
        Row(
          spacing: 12,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CustomNetWorkImageView(
                  url: ApiUrlConst.testImgUrl(),
                  radius: 14,
                  height: ScreenUtils.nw() / 2,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CustomNetWorkImageView(
                  url: ApiUrlConst.testImgUrl(),
                  radius: 14,
                  height: ScreenUtils.nw() / 2,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
