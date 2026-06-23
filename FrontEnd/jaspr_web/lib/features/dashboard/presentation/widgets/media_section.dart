import 'dart:async';
import 'package:jaspr/dom.dart' hide BorderRadius, Padding;
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';
import 'package:jaspr_app/shared/constants/assects_const.dart';
import 'package:jaspr_app/shared/constants/theme.dart';
import 'package:jaspr_app/shared/ui/ui.dart';
import 'package:jaspr_app/shared/utils/pop_up_items.dart';
import 'package:jaspr_app/navigation/route_names.dart';

class YoutubeInAppWebviewPlayer extends StatelessComponent {
  final String videoUrl;
  final double height;
  final bool fullScreen;

  const YoutubeInAppWebviewPlayer({
    required this.videoUrl,
    required this.height,
    required this.fullScreen,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    final uri = Uri.parse(videoUrl);
    String videoId = 'CIfLE0CShbg';
    if (uri.queryParameters.containsKey('v')) {
      videoId = uri.queryParameters['v']!;
    }
    return iframe(
      src: 'https://www.youtube.com/embed/$videoId',
      attributes: {
        'width': '100%',
        'height': '${height}px',
        'frameborder': '0',
        'allow': 'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share',
        if (fullScreen) 'allowfullscreen': 'true',
      },
      [],
    );
  }
}

class CarouselSlider extends StatefulComponent {
  final List<String> imageList;
  final Duration autoScrollDuration;
  final void Function(int)? onTap;
  final double height;
  final double radius;

  const CarouselSlider({
    required this.imageList,
    required this.autoScrollDuration,
    this.onTap,
    required this.height,
    required this.radius,
    super.key,
  });

  @override
  State<CarouselSlider> createState() => _CarouselSliderState();
}

class _CarouselSliderState extends State<CarouselSlider> {
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(component.autoScrollDuration, (timer) {
      if (!mounted) return;
      setState(() {
        _currentIndex = (_currentIndex + 1) % component.imageList.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    if (component.imageList.isEmpty) return div([]);

    return div(
      classes: 'carousel-container',
      styles: Styles(raw: {
        'position': 'relative',
        'width': '100%',
        'height': '${component.height}px',
        'overflow': 'hidden',
        'border-radius': '${component.radius}px',
      }),
      [
        // Current image
        div(
          classes: 'carousel-slide',
          events: {
            if (component.onTap != null) 'click': (event) => component.onTap!(_currentIndex),
          },
          styles: Styles(raw: {
            'width': '100%',
            'height': '100%',
            'background-image': 'url(${component.imageList[_currentIndex]})',
            'background-size': 'cover',
            'background-position': 'center',
            'cursor': component.onTap != null ? 'pointer' : 'default',
            'transition': 'background-image 0.5s ease-in-out',
          }),
          [],
        ),
        // Dots indicator
        div(
          classes: 'carousel-indicators',
          styles: Styles(raw: {
            'position': 'absolute',
            'bottom': '16px',
            'left': '50%',
            'transform': 'translateX(-50%)',
            'display': 'flex',
            'gap': '8px',
            'z-index': '10',
          }),
          List.generate(component.imageList.length, (index) {
            final isActive = index == _currentIndex;
            return div(
              events: {
                'click': (event) {
                  _timer?.cancel();
                  setState(() {
                    _currentIndex = index;
                  });
                  _startTimer();
                }
              },
              styles: Styles(raw: {
                'width': '8px',
                'height': '8px',
                'border-radius': '50%',
                'background-color': isActive ? 'white' : 'rgba(255, 255, 255, 0.5)',
                'cursor': 'pointer',
                'transition': 'all 0.3s ease',
                if (isActive) 'transform': 'scale(1.2)',
              }),
              [],
            );
          }),
        ),
      ],
    );
  }
}

class MediaSection extends StatelessComponent {
  const MediaSection({super.key});

  @override
  Component build(BuildContext context) {
    return Column(
      gap: 20,
      children: [
        // YouTube Player
        _MediaCard(
          label: "Featured Video",
          icon: AssetsConst.featherYoutube,
          child: const YoutubeInAppWebviewPlayer(
            videoUrl: "https://www.youtube.com/watch?v=CIfLE0CShbg",
            height: 220,
            fullScreen: true,
          ),
        ),

        // Image Pair: Gallery
        Row(
          gap: 12,
          children: [
            Expanded(
              child: _ImageCardWithOverlay(
                url: AssetsConst.accurateReport,
                height: 180,
                label: "Gallery",
                onTap: () {
                  PopUpItems.toastMessage("On Tap Gallery", baseHexColor);
                },
              ),
            ),
            Expanded(
              child: _ImageCardWithOverlay(
                url: AssetsConst.nsbl,
                height: 180,
                label: "Explore",
              ),
            ),
          ],
        ),

        // Featured Carousel
        _MediaCard(
          label: "Featured Collection",
          icon: AssetsConst.featherGrid,
          child: CarouselSlider(
            radius: 14,
            autoScrollDuration: const Duration(seconds: 4),
            imageList: const [
              AssetsConst.genuLogo,
              AssetsConst.appRatingScreenImage,
              AssetsConst.somethingWentWrong,
              AssetsConst.noRecordFound,
              AssetsConst.pageNotFound,
            ],
            onTap: (index) {
              Router.of(context).push(RouteName.games);
            },
            height: 400,
          ),
        ),

        // Image pair: Showcase
        Row(
          gap: 12,
          children: [
            Expanded(
              child: _ImageCardWithOverlay(
                url: AssetsConst.genuLogo,
                height: 180,
                label: "Showcase",
              ),
            ),
            Expanded(
              child: _ImageCardWithOverlay(
                url: AssetsConst.appRatingScreenImage,
                height: 180,
                label: "Discover",
              ),
            ),
          ],
        ),

        // Small image pair
        Row(
          gap: 12,
          children: [
            Expanded(
              child: _ImageCardWithOverlay(
                url: AssetsConst.helpButtonDesign,
                height: 100,
                label: "Trending",
              ),
            ),
            Expanded(
              child: _ImageCardWithOverlay(
                url: AssetsConst.pinCodePickerDesign,
                height: 100,
                label: "Accessories",
              ),
            ),
          ],
        ),

        // Second Carousel
        _MediaCard(
          label: "More to Explore",
          icon: AssetsConst.featherCompass,
          child: CarouselSlider(
            radius: 14,
            autoScrollDuration: const Duration(seconds: 4),
            imageList: const [
              AssetsConst.genuLogo,
              AssetsConst.appRatingScreenImage,
              AssetsConst.somethingWentWrong,
              AssetsConst.noRecordFound,
              AssetsConst.pageNotFound,
            ],
            onTap: (index) {
              if (index == 0) {
                 Router.of(context).push(RouteName.games);
              }  else {
                  PopUpItems.toastMessage("Carousel Item $index Clicked", baseHexColor);
              }
            },
            height: 400,
          ),
        ),

        // Final image pair
        Row(
          gap: 12,
          children: [
            Expanded(
              child: _ImageCardWithOverlay(
                url: AssetsConst.somethingWentWrong,
                height: 180,
                label: "Inspire",
              ),
            ),
            Expanded(
              child: _ImageCardWithOverlay(
                url: AssetsConst.noRecordFound,
                height: 180,
                label: "Create",
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MediaCard extends StatelessComponent {
  final Component child;
  final String? label;
  final String? icon;

  const _MediaCard({
    required this.child,
    this.label,
    this.icon,
  });

  @override
  Component build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg.value,
        borderRadius: BorderRadius.circular(18),
      ),
      style: Styles(raw: {
        'box-shadow': '0 4px 16px rgba(0, 0, 0, 0.07)',
        'border': '1px solid rgba(0, 0, 0, 0.04)',
        'display': 'flex',
        'flex-direction': 'column',
        'width': '100%',
        'overflow': 'hidden',
      }),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (label != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    img(
                      src: icon!,
                      styles: Styles(raw: {'width': '14px', 'height': '14px', 'opacity': '0.7'}),
                    ),
                    const SizedBox(width: 6),
                  ],
                  CustomText(
                    label!,
                    variant: TextVariant.bodySmall,
                    color: secondaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          div(
            styles: Styles(raw: {
              'border-radius': label != null ? '0 0 18px 18px' : '18px',
              'overflow': 'hidden',
              'display': 'flex',
              'flex-direction': 'column',
            }),
            [child],
          ),
        ],
      ),
    );
  }
}

class _ImageCardWithOverlay extends StatelessComponent {
  final String url;
  final double height;
  final String? label;
  final VoidCallback? onTap;

  const _ImageCardWithOverlay({
    required this.url,
    required this.height,
    this.label,
    this.onTap,
  });

  @override
  Component build(BuildContext context) {
    return div(
      events: {
        if (onTap != null) 'click': (event) => onTap!(),
      },
      styles: Styles(raw: {
        'height': '${height}px',
        'border-radius': '16px',
        'overflow': 'hidden',
        'position': 'relative',
        'cursor': onTap != null ? 'pointer' : 'default',
        'box-shadow': '0 4px 12px rgba(0, 0, 0, 0.08)',
        'transition': 'transform 0.2s ease',
      }),
      [
        img(
          src: url,
          styles: Styles(raw: {
            'width': '100%',
            'height': '100%',
            'object-fit': 'cover',
          }),
        ),
        // Gradient overlay
        div(
          styles: Styles(raw: {
            'position': 'absolute',
            'top': '0',
            'left': '0',
            'width': '100%',
            'height': '100%',
            'background': 'linear-gradient(to bottom, transparent 0%, transparent 50%, rgba(0, 0, 0, 0.5) 100%)',
            'pointer-events': 'none',
          }),
          [],
        ),
        // Label
        if (label != null)
          Positioned(
            left: 12,
            bottom: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              style: Styles(raw: {
                'background-color': 'rgba(255, 255, 255, 0.2)',
                'backdrop-filter': 'blur(4px)',
              }),
              child: CustomText(
                label!,
                color: Colors.white,
                variant: TextVariant.caption,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
