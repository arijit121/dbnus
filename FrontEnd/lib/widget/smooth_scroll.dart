import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

const int NORMAL_SCROLL_ANIMATION_LENGTH_MS = 250;
const double SCROLL_SPEED = 130;

class SmoothScroll extends StatefulWidget {
  final ScrollController? controller;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;
  final bool? primary;
  final bool shrinkWrap;
  final Axis scrollDirection;

  // For children-based constructor
  final List<Widget>? children;

  // For builder-based constructor
  final int? itemCount;
  final IndexedWidgetBuilder? itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;

  const SmoothScroll({
    super.key,
    required this.children,
    this.controller,
    this.physics,
    this.padding,
    this.primary,
    this.shrinkWrap = false,
    this.scrollDirection = Axis.vertical,
  })  : itemCount = null,
        itemBuilder = null,
        separatorBuilder = null;

  const SmoothScroll.builder({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.separatorBuilder,
    this.controller,
    this.physics,
    this.padding,
    this.primary,
    this.shrinkWrap = false,
    this.scrollDirection = Axis.vertical,
  }) : children = null;

  @override
  State<SmoothScroll> createState() => _SmoothScrollState();
}

class _SmoothScrollState extends State<SmoothScroll> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? ScrollController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shouldSmoothScroll = kIsWeb || isDesktop();

    final physics = widget.physics ?? const AlwaysScrollableScrollPhysics();

    Widget listView;

    if (widget.children != null) {
      listView = ListView(
        controller: _controller,
        physics: physics,
        padding: widget.padding,
        primary: widget.primary,
        shrinkWrap: widget.shrinkWrap,
        scrollDirection: widget.scrollDirection,
        children: widget.children!,
      );
    } else if (widget.separatorBuilder != null) {
      listView = ListView.separated(
        controller: _controller,
        physics: physics,
        padding: widget.padding,
        itemCount: widget.itemCount!,
        itemBuilder: widget.itemBuilder!,
        separatorBuilder: widget.separatorBuilder!,
        primary: widget.primary,
        shrinkWrap: widget.shrinkWrap,
        scrollDirection: widget.scrollDirection,
      );
    } else {
      listView = ListView.builder(
        controller: _controller,
        physics: physics,
        padding: widget.padding,
        itemCount: widget.itemCount!,
        itemBuilder: widget.itemBuilder!,
        primary: widget.primary,
        shrinkWrap: widget.shrinkWrap,
        scrollDirection: widget.scrollDirection,
      );
    }

    if (!shouldSmoothScroll) return listView;

    return SmoothScrollWrapper(
      controller: _controller,
      child: listView,
    );
  }

  bool isDesktop() {
    return defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux;
  }
}

class SmoothScrollWrapper extends StatefulWidget {
  const SmoothScrollWrapper(
      {super.key, required this.controller, required this.child});

  final ScrollController controller;
  final Widget child;

  @override
  State<SmoothScrollWrapper> createState() => _SmoothScrollWrapperState();
}

class _SmoothScrollWrapperState extends State<SmoothScrollWrapper> {
  late final ScrollController _controller;
  double _scrollPosition = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? ScrollController();
    _scrollPosition = _controller.initialScrollOffset;
    _controller.addListener(_updateScrollPosition);
  }

  void _updateScrollPosition() {
    _scrollPosition = _controller.position.pixels;
  }

  @override
  void dispose() {
    _controller.removeListener(_updateScrollPosition);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (pointerSignal) {
        if (pointerSignal is PointerScrollEvent) {
          int duration = NORMAL_SCROLL_ANIMATION_LENGTH_MS;
          _scrollPosition +=
              pointerSignal.scrollDelta.dy > 0 ? SCROLL_SPEED : -SCROLL_SPEED;

          final max = _controller.position.maxScrollExtent;
          final min = _controller.position.minScrollExtent;

          if (_scrollPosition > max) {
            _scrollPosition = max;
            duration ~/= 2;
          } else if (_scrollPosition < min) {
            _scrollPosition = min;
            duration ~/= 2;
          }

          _controller.animateTo(
            _scrollPosition,
            duration: Duration(milliseconds: duration),
            curve: Curves.easeOutCubic,
          );
        }
      },
      behavior: HitTestBehavior.deferToChild,
      child: widget.child,
    );
  }
}
