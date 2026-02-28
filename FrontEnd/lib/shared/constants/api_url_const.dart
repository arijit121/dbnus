import 'dart:math';

import 'package:dbnus/flavors.dart';

class ApiUrlConst {
  static String baseUrl = F.appFlavor == Flavor.stg
      ? "https://www.stg-googleapis.com/"
      : F.appFlavor == Flavor.dev
          ? "https://www.dev-googleapis.com/"
          : "https://www.googleapis.com/";

  static String books = "${baseUrl}books/v1/volumes";
  static String hostUrl = "https://dbnus-df986.web.app";

  static String testImgUrl({num aspectRatio = 1}) {
    int width = Random().nextInt(2160) + 512;
    int height = (width / aspectRatio).toInt();
    return "https://picsum.photos/$width/$height.jpg";
  }
}
