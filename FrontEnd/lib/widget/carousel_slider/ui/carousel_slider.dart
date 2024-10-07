import 'package:dbnus/extension/spacing.dart';
import 'package:dbnus/service/redirect_engine.dart';
import 'package:dbnus/service/value_handler.dart';
import 'package:dbnus/widget/custom_image.dart';
import 'package:flutter/material.dart';

import '../model/carousel_slider_model.dart';

import 'dart:async';

class CarouselSlider extends StatefulWidget {
  const CarouselSlider({
    super.key,
    required this.sliderList,
    this.autoScrollDuration = const Duration(seconds: 2),
    this.transitionDuration = const Duration(milliseconds: 600),
    this.scaleFactor = 0.9,
    this.fadeFactor = 0.5,
  });

  final List<CarouselSliderModel> sliderList;
  final Duration autoScrollDuration;
  final Duration transitionDuration;
  final double scaleFactor;
  final double fadeFactor;

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
    _pageController = PageController(initialPage: 0);
    _currentIndex.value = 0; // Set the initial current index.
    if (widget.sliderList.length > 1) {
      _startAutoScroll();
    }
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel(); // Cancel existing timer if any
    _autoScrollTimer = Timer.periodic(widget.autoScrollDuration, (timer) {
      int nextIndex = _pageController.page!.toInt() + 1;

      // Apply special animation when nextIndex is a loop
      final duration = nextIndex % widget.sliderList.length == 0
          ? widget.transitionDuration + const Duration(milliseconds: 200)
          : widget.transitionDuration;

      _pageController.animateToPage(
        nextIndex,
        duration: duration,
        curve: Curves.easeInOut,
      );
      _currentIndex.value = nextIndex % widget.sliderList.length;
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
      height: 400,
      child: Column(
        children: [
          Expanded(child: _buildPageView()),
          4.ph,
          _buildIndicator(),
        ],
      ),
    );
  }

  Widget _buildPageView() {
    return ValueListenableBuilder<int>(
      valueListenable: _currentIndex,
      builder: (_, __, ___) {
        return PageView.builder(
          controller: _pageController,
          onPageChanged: (newIndex) {
            // Calculate the correct index by using modulo operation
            int actualIndex = newIndex % widget.sliderList.length;
            _currentIndex.value = actualIndex;
          },
          itemBuilder: (context, pageIndex) {
            // Use modulo to repeat the list infinitely
            int actualIndex = pageIndex % widget.sliderList.length;
            return _buildPageItem(actualIndex);
          },
        );
      },
    );
  }

  Widget _buildPageItem(int pageIndex) {
    final bool isActive = pageIndex == _currentIndex.value;
    return GestureDetector(
      onTap: () {
        final actionUrl = widget.sliderList.elementAt(pageIndex).actionUrl;
        if (ValueHandler().isTextNotEmptyOrNull(actionUrl)) {
          RedirectEngine().redirectRoutes(
            redirectUrl: Uri.parse(actionUrl!),
          );
        }
      },
      child: Transform.scale(
        scale: isActive ? 1.0 : widget.scaleFactor,
        child: Opacity(
          opacity: isActive ? 1.0 : widget.fadeFactor,
          child: CustomNetWorkImageView(
            radius: 8,
            url: widget.sliderList.elementAt(pageIndex).imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator() {
    return ValueListenableBuilder<int>(
      valueListenable: _currentIndex,
      builder: (context, index, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.sliderList.length, (i) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i == index ? Colors.blue : Colors.grey,
              ),
            );
          }),
        );
      },
    );
  }
}