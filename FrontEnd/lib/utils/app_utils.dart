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
