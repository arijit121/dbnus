import 'dart:async';

import 'package:flutter/material.dart';

import '../const/color_const.dart';
import 'custom_image.dart';

class CarouselSlider extends StatefulWidget {
  const CarouselSlider({
    super.key,
    required this.imageList,
    this.autoScrollDuration = const Duration(seconds: 2),
    this.transitionDuration = const Duration(milliseconds: 600),
    this.scaleFactor = 0.9,
    this.fadeFactor = 0.5,
    required this.height,
    this.onTap,
    this.onPageChanged,
    this.noScroll,
    this.padding,
    this.radius,
    this.fit = BoxFit.contain,
    this.initialIndex = 0,
  });

  final List<String> imageList;
  final Duration autoScrollDuration;
  final Duration transitionDuration;
  final double scaleFactor, fadeFactor, height;
  final void Function(int index)? onTap;
  final void Function(int)? onPageChanged;
  final bool? noScroll;
  final EdgeInsetsGeometry? padding;
  final double? radius;
  final BoxFit fit;
  final int initialIndex;

  @override
  State<CarouselSlider> createState() => _CarouselSliderState();
}

class _CarouselSliderState extends State<CarouselSlider> {
  late PageController _pageController;
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    // Initialize PageController with a large initial page value to allow seamless scrolling.
    _pageController = PageController(initialPage: widget.initialIndex);
    _currentIndex.value = widget.initialIndex; // Set the initial current index.
    if (widget.imageList.length > 1 && widget.noScroll != true) {
      _startAutoScroll();
    }
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel(); // Cancel existing timer if any
    _autoScrollTimer = Timer.periodic(widget.autoScrollDuration, (timer) {
      int nextIndex = _pageController.page!.toInt() + 1;

      // Apply special animation when nextIndex is a loop
      final duration = nextIndex % widget.imageList.length == 0
          ? widget.transitionDuration + const Duration(milliseconds: 200)
          : widget.transitionDuration;

      _pageController.animateToPage(
        nextIndex,
        duration: duration,
        curve: Curves.easeInOut,
      );
      _currentIndex.value = nextIndex % widget.imageList.length;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentIndex.dispose();
    _autoScrollTimer?.cancel(); // Cancel timer on dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Column(
        children: [
          Expanded(child: _buildPageView()),
          if (widget.imageList.length > 1) ...[
            const SizedBox(height: 4),
            _buildIndicator(),
          ],
        ],
      ),
    );
  }

  Widget _buildPageView() {
    return ValueListenableBuilder<int>(
      valueListenable: _currentIndex,
      builder: (_, __, ___) {
        return PageView.builder(
          physics: widget.imageList.length == 1
              ? const NeverScrollableScrollPhysics()
              : null,
          controller: _pageController,
          onPageChanged: (newIndex) {
            // Calculate the correct index by using modulo operation
            int actualIndex = newIndex % widget.imageList.length;
            _currentIndex.value = actualIndex;
            if (widget.onPageChanged != null) {
              widget.onPageChanged!(actualIndex);
            }
          },
          itemBuilder: (context, pageIndex) {
            // Use modulo to repeat the list infinitely
            int actualIndex = pageIndex % widget.imageList.length;
            return Container(
              padding: widget.padding,
              child: _buildPageItem(actualIndex),
            );
          },
        );
      },
    );
  }

  Widget _buildPageItem(int pageIndex) {
    final bool isActive = pageIndex == _currentIndex.value;
    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!(pageIndex);
        }
      },
      child: Transform.scale(
        scale: isActive ? 1.0 : widget.scaleFactor,
        child: Opacity(
          opacity: isActive ? 1.0 : widget.fadeFactor,
          child: CustomNetWorkImageView(
            radius: widget.radius,
            url: widget.imageList.elementAt(pageIndex),
            fit: widget.fit,
            width: double.infinity,
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator() {
    return Container(
      padding: widget.padding,
      child: ValueListenableBuilder<int>(
        valueListenable: _currentIndex,
        builder: (context, index, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.imageList.length, (i) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i == index ? Colors.blue : ColorConst.grey,
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
