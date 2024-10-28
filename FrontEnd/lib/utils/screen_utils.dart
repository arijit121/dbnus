import 'package:flutter/material.dart';

import '../service/context_service.dart';

class ScreenUtils {
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
