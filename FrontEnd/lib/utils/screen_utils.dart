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

  /// [responsiveUI] is reusable widget which can decide that ui is large, medium or narrow
  ///
  static Widget responsiveUI(
      {Widget? narrowUI, Widget? mediumUI, Widget? largeUI}) {
    return OrientationBuilder(builder: (context, orientation) {
      if (MediaQuery.of(context).size.width > mediumWidthBreakpoint) {
        return largeUI ?? const Placeholder();
      } else if (MediaQuery.of(context).size.width >
          narrowScreenWidthThreshold) {
        return mediumUI ?? const Placeholder();
      }
      return narrowUI ?? const Placeholder();
    });
  }
}
