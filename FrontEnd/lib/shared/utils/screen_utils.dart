import 'package:material_ui/material_ui.dart';

import 'package:dbnus/core/services/context_service.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ScreenUtils {
  static double devicePixelRatio() =>
      MediaQuery.of(CurrentContext().context).devicePixelRatio;

  static double paddingLeft() =>
      MediaQuery.of(CurrentContext().context).padding.left;

  static double paddingRight() =>
      MediaQuery.of(CurrentContext().context).padding.right;

  static double paddingTop() =>
      MediaQuery.of(CurrentContext().context).padding.top;

  static double paddingBottom() =>
      MediaQuery.of(CurrentContext().context).padding.bottom;

  static double aw() => MediaQuery.of(CurrentContext().context).size.width;

  static double ah() => MediaQuery.of(CurrentContext().context).size.height;

  static double nw() =>
      (MediaQuery.of(CurrentContext().context).size.width) -
      (MediaQuery.of(CurrentContext().context).padding.left) -
      (MediaQuery.of(CurrentContext().context).padding.right);

  static double nh() =>
      MediaQuery.of(CurrentContext().context).size.height -
      (MediaQuery.of(CurrentContext().context).padding.top) -
      (MediaQuery.of(CurrentContext().context).padding.bottom);

  static double getAspectRation(
      {required double height, required double width}) {
    try {
      return width / height;
    } catch (e) {
      return 1;
    }
  }

  static bool isWidgetVisible(BuildContext? context) {
    if (context == null) return false;

    final renderObject = context.findRenderObject();

    if (renderObject is! RenderBox ||
        !renderObject.hasSize ||
        !renderObject.attached) {
      return false;
    }

    final size = renderObject.size;

    if (size.width <= 0 || size.height <= 0) {
      return false;
    }

    final position = renderObject.localToGlobal(Offset.zero);

    final screenSize = MediaQuery.sizeOf(context);

    final rect = Rect.fromLTWH(
      position.dx,
      position.dy,
      size.width,
      size.height,
    );

    final screenRect = Rect.fromLTWH(
      0,
      0,
      screenSize.width,
      screenSize.height,
    );

    return rect.overlaps(screenRect);
  }

  static double getVisiblePercentage(BuildContext? context) {
    if (context == null) return 0.0;

    final renderObject = context.findRenderObject();

    if (renderObject is! RenderBox ||
        !renderObject.hasSize ||
        !renderObject.attached) {
      return 0.0;
    }

    final size = renderObject.size;

    if (size.width <= 0 || size.height <= 0) {
      return 0.0;
    }

    final position = renderObject.localToGlobal(Offset.zero);
    final screenSize = MediaQuery.sizeOf(context);

    final widgetRect = Rect.fromLTWH(
      position.dx,
      position.dy,
      size.width,
      size.height,
    );

    final screenRect = Rect.fromLTWH(
      0,
      0,
      screenSize.width,
      screenSize.height,
    );

    final intersection = widgetRect.intersect(screenRect);

    if (intersection.isEmpty) {
      return 0.0;
    }

    final visibleArea = intersection.width * intersection.height;

    final totalArea = size.width * size.height;

    return ((visibleArea / totalArea) * 100).clamp(0.0, 100.0);
  }
}

class ResponsiveUI extends StatelessWidget {
  final Widget? Function(BuildContext context) narrowUI;
  final Widget? Function(BuildContext context) mediumUI;
  final Widget? Function(BuildContext context) largeUI;

  /// [ResponsiveUI] is reusable widget which can decide that ui is large, medium or narrow
  ///
  const ResponsiveUI({
    super.key,
    required this.narrowUI,
    required this.mediumUI,
    required this.largeUI,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, BoxConstraints constraints) {
        double screenWidth = MediaQuery.of(context).size.width;
        if (screenWidth > WidthState.medium.value) {
          return largeUI(context) ?? const Placeholder();
        } else if (screenWidth > WidthState.narrow.value) {
          return mediumUI(context) ?? const Placeholder();
        } else {
          return narrowUI(context) ?? const Placeholder();
        }
      },
    );
  }
}

/// The signature of the [ResponsiveBuilder] builder function.
typedef ResponsiveWidgetBuilder = Widget Function(
    BuildContext context, WidthState widthState);

class ResponsiveBuilder extends StatelessWidget {
  ///
  /// ResponsiveBuilder  provide what is the [WidthState] of the widget.
  ///
  /// What is WidthState?
  /// [WidthState] is enum for screen width (narrow, medium, large).
  ///
  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });

  final ResponsiveWidgetBuilder builder;

  Widget _buildWithConstraints(
      BuildContext context, BoxConstraints constraints) {
    double screenWidth = MediaQuery.of(context).size.width;
    WidthState responsiveState = screenWidth > WidthState.medium.value
        ? WidthState.large
        : screenWidth > WidthState.narrow.value
            ? WidthState.medium
            : WidthState.narrow;

    return builder(context, responsiveState);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: _buildWithConstraints);
  }
}

class CustomVisibilityDetector extends StatefulWidget {
  final Widget child;
  final void Function(double visiblePercentage) onVisibilityChanged;
  final double minVisibleFraction;
  final bool oneTime;

  const CustomVisibilityDetector({
    super.key,
    required this.child,
    required this.onVisibilityChanged,
    this.minVisibleFraction = 0.3,
    this.oneTime = true,
  });

  @override
  State<CustomVisibilityDetector> createState() =>
      _CustomVisibilityDetectorState();
}

class _CustomVisibilityDetectorState extends State<CustomVisibilityDetector> {
  bool _hasLogged = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (ScreenUtils.isWidgetVisible(context)) {
        double visiblePercentage =
            ScreenUtils.getVisiblePercentage(context) / 100;
        if (visiblePercentage >= widget.minVisibleFraction &&
            (!widget.oneTime || !_hasLogged)) {
          widget.onVisibilityChanged(visiblePercentage);
          _hasLogged = true;
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.child.hashCode.toString()),
      onVisibilityChanged: (visibilityInfo) {
        var visiblePercentage = visibilityInfo.visibleFraction;
        if (visiblePercentage >= widget.minVisibleFraction &&
            (!widget.oneTime || !_hasLogged)) {
          widget.onVisibilityChanged(visiblePercentage);
          _hasLogged = true;
        }
      },
      child: widget.child,
    );
  }
}

///
/// [WidthState] is enum for screen width (narrow, medium, large).
///
enum WidthState {
  narrow(540, "narrow"),
  medium(1000, "medium"),
  large(1500, "large");

  final int value;
  final String name;

  const WidthState(this.value, this.name);
}
