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
    _pageController = PageController();
    if (widget.sliderList.length > 1) {
      _startAutoScroll();
    }
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel(); // Cancel existing timer if any
    _autoScrollTimer = Timer.periodic(widget.autoScrollDuration, (timer) {
      int nextIndex = (_currentIndex.value + 1) % widget.sliderList.length;

      // Apply special animation when nextIndex is 0 (loop back to first page)
      final curve = nextIndex == 0 ? Curves.elasticOut : Curves.easeInOut;
      final duration = nextIndex == 0
          ? widget.transitionDuration + const Duration(milliseconds: 200)
          : widget.transitionDuration;

      _pageController.animateToPage(
        nextIndex,
        duration: duration,
        curve: curve,
      );
      _currentIndex.value = nextIndex;
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
          itemCount: widget.sliderList.length,
          onPageChanged: (newIndex) {
            _currentIndex.value = newIndex;
          },
          itemBuilder: (context, pageIndex) {
            return _buildPageItem(pageIndex);
          },
        );
      },
    );
  }

  Widget _buildPageItem(int pageIndex) {
    final bool isActive = pageIndex == _currentIndex.value;
    final bool isLoopingBack =
        _currentIndex.value == widget.sliderList.length - 1 && pageIndex == 0;

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
        scale: isLoopingBack
            ? 1.05 // Pop a little more when transitioning back to the first page
            : isActive
                ? 1.0
                : widget.scaleFactor,
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
