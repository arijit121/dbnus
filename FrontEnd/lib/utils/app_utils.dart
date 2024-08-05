import 'screen_utils.dart';

class AppUtils {
  int gridViewCount({required double elementWidth, double? extra}) {
    double valExtra = extra ?? 0;
    return ((ScreenUtils.nw() - valExtra) ~/ elementWidth) > 1
        ? ((ScreenUtils.nw() - valExtra) ~/ elementWidth)
        : 1;
  }

  double gridViewRation(
      {required double elementWidth,
      required double elementHeight,
      double? extra}) {
    int valGridViewCount =
        gridViewCount(elementWidth: elementWidth, extra: extra);
    return (ScreenUtils.nw() / valGridViewCount) / elementHeight;
  }
}
