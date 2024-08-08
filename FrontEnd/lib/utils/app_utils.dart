import 'screen_utils.dart';

class AppUtils {
  int gridViewCount({required num elementWidth, num? extra}) {
    num valExtra = extra ?? 0;
    return ((ScreenUtils.nw() - valExtra) ~/ elementWidth) > 1
        ? ((ScreenUtils.nw() - valExtra) ~/ elementWidth)
        : 1;
  }

  double gridViewRation(
      {required num elementWidth, required num elementHeight, num? extra}) {
    int valGridViewCount =
        gridViewCount(elementWidth: elementWidth, extra: extra);
    return (ScreenUtils.nw() / valGridViewCount) / elementHeight;
  }
}
