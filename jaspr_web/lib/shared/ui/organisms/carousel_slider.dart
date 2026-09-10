import 'dart:async';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import '../../constants/color_const.dart';
import '../ui.dart';

class CarouselSlider extends StatefulComponent {
  final List<String> imageList;
  final Duration autoScrollDuration;
  final double height;
  final void Function(int index)? onTap;
  final void Function(int)? onPageChanged;
  final bool? noScroll;
  final double? radius;
  final BoxFit fit;
  final int initialIndex;
  final String? className;

  const CarouselSlider({
    required this.imageList,
    this.autoScrollDuration = const Duration(seconds: 3),
    required this.height,
    this.onTap,
    this.onPageChanged,
    this.noScroll,
    this.radius = 12.0,
    this.fit = BoxFit.cover,
    this.initialIndex = 0,
    this.className,
    super.key,
  });

  @override
  State<CarouselSlider> createState() => _CarouselSliderState();
}

class _CarouselSliderState extends State<CarouselSlider> {
  late int _currentIndex;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _currentIndex = component.initialIndex;
    _startAutoScroll();
  }

  void _startAutoScroll() {
    if (component.imageList.length > 1 && component.noScroll != true) {
      _autoScrollTimer?.cancel();
      _autoScrollTimer = Timer.periodic(component.autoScrollDuration, (timer) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % component.imageList.length;
        });
        component.onPageChanged?.call(_currentIndex);
      });
    }
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    if (component.imageList.isEmpty) return const SizedBox();

    return Container(
      className: component.className,
      width: double.infinity,
      style: Styles(raw: {
        'display': 'flex',
        'flex-direction': 'column',
        'align-items': 'center',
        'gap': '8px',
      }),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Carousel slide
          div(
            events: {
              'click': (e) => component.onTap?.call(_currentIndex),
            },
            styles: Styles(raw: {
              'width': '100%',
              'height': '${component.height}px',
              'border-radius': component.radius != null ? '${component.radius}px' : '0px',
              'overflow': 'hidden',
              'position': 'relative',
              if (component.onTap != null) 'cursor': 'pointer',
            }),
            [
              CustomNetWorkImageView(
                url: component.imageList[_currentIndex],
                width: double.infinity,
                height: component.height,
                fit: component.fit,
                radius: component.radius,
              ),
            ],
          ),
          // Indicators
          if (component.imageList.length > 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(component.imageList.length, (dotIndex) {
                final isActive = dotIndex == _currentIndex;
                return div(
                  events: {
                    'click': (e) {
                      setState(() => _currentIndex = dotIndex);
                      component.onPageChanged?.call(dotIndex);
                    }
                  },
                  styles: Styles(raw: {
                    'width': isActive ? '20px' : '8px',
                    'height': '8px',
                    'margin': '0 4px',
                    'border-radius': '4px',
                    'background-color': isActive ? ColorConst.baseHexColor.value : ColorConst.grey.value,
                    'transition': 'all 0.3s ease',
                    'cursor': 'pointer',
                  }),
                  [],
                );
              }),
            ),
        ],
      ),
    );
  }
}
