import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import 'screen_utils.dart';

class AppUtils {
  Future<Position> getCurrentPosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      if (kIsWeb) {
        permission = await Geolocator.requestPermission();
      } else {
        await Geolocator.openAppSettings();
        permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.deniedForever) {
          return Future.error(
              'Location permissions are permanently denied, we cannot request permissions.');
        }
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  int gridViewCount(
      {required num elementWidth, num? extra, double crossAxisSpacing = 0}) {
    num valExtra = extra ?? 0;
    double screenWidth = ScreenUtils.nw() - valExtra + crossAxisSpacing;
    double aElementWidth = elementWidth + crossAxisSpacing;
    return ((screenWidth) ~/ aElementWidth) > 1
        ? ((screenWidth) ~/ aElementWidth)
        : 1;
  }

  double gridViewRation(
      {required num elementWidth,
      required num elementHeight,
      num? extra,
      double crossAxisSpacing = 0}) {
    num valExtra = extra ?? 0;
    int valGridViewCount = gridViewCount(
        elementWidth: elementWidth,
        extra: extra,
        crossAxisSpacing: crossAxisSpacing);
    // if (valGridViewCount > 1) {
    //   valExtra = valExtra + (crossAxisSpacing * (valGridViewCount - 1));
    // }

    return ((ScreenUtils.nw() - valExtra) / valGridViewCount) / elementHeight;
  }
}
