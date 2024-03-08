import 'package:flutter/material.dart';

import '../service/context_service.dart';

class ScreenUtils {
  static double paddingLeft = MediaQuery.of(CurrentContext().context).padding.left;
  static double paddingRight = MediaQuery.of(CurrentContext().context).padding.right;
  static double paddingTop = MediaQuery.of(CurrentContext().context).padding.top;
  static double paddingBottom = MediaQuery.of(CurrentContext().context).padding.bottom;
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
