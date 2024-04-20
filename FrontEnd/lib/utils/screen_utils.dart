import 'package:flutter/material.dart';

import '../extension/logger_extension.dart';
import '../service/context_service.dart';

class ScreenUtils {
  static double narrowScreenWidthThreshold = 450;

  static double mediumWidthBreakpoint = 1000;
  static double largeWidthBreakpoint = 1500;
  static double paddingLeft =
      MediaQuery.of(CurrentContext().context).padding.left;
  static double paddingRight =
      MediaQuery.of(CurrentContext().context).padding.right;
  static double paddingTop =
      MediaQuery.of(CurrentContext().context).padding.top;
  static double paddingBottom =
      MediaQuery.of(CurrentContext().context).padding.bottom;
  static double aw = MediaQuery.of(CurrentContext().context).size.width;
  static double ah = MediaQuery.of(CurrentContext().context).size.height;
  static double nw = (MediaQuery.of(CurrentContext().context).size.width) -
      (MediaQuery.of(CurrentContext().context).padding.left) -
      (MediaQuery.of(CurrentContext().context).padding.right);
  static double nh = MediaQuery.of(CurrentContext().context).size.height -
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
    return OrientationBuilder(
      builder: (context, orientation) {
        final screenWidth = MediaQuery.of(context).size.width;

        if (screenWidth > ScreenUtils.mediumWidthBreakpoint) {
          return largeUI(context) ?? const Placeholder();
        } else if (screenWidth > ScreenUtils.narrowScreenWidthThreshold) {
          return mediumUI(context) ?? const Placeholder();
        } else {
          return narrowUI(context) ?? const Placeholder();
        }
      },
    );
  }
}
