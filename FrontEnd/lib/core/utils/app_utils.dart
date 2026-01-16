import 'package:dbnus/core/utils/screen_utils.dart';

class AppUtils {
  static int gridViewCount(
      {required num elementWidth, num? extra, double crossAxisSpacing = 0}) {
    num valExtra = extra ?? 0;
    double screenWidth = ScreenUtils.nw() - valExtra + crossAxisSpacing;
    double aElementWidth = elementWidth + crossAxisSpacing;
    return ((screenWidth) ~/ aElementWidth) > 1
        ? ((screenWidth) ~/ aElementWidth)
        : 1;
  }

  static double gridViewRation(
      {required num elementWidth,
      required num elementHeight,
      num? extra,
      double crossAxisSpacing = 0}) {
    num valExtra = extra ?? 0;
    int valGridViewCount = AppUtils.gridViewCount(
        elementWidth: elementWidth,
        extra: extra,
        crossAxisSpacing: crossAxisSpacing);
    // if (valGridViewCount > 1) {
    //   valExtra = valExtra + (crossAxisSpacing * (valGridViewCount - 1));
    // }

    return ((ScreenUtils.nw() - valExtra) / valGridViewCount) / elementHeight;
  }
}
