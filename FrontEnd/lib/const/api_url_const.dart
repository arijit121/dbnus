import 'dart:math';

import '../flavors.dart';

class ApiUrlConst {
  static String baseUrl = F.appFlavor == Flavor.prod
      ? "https://www.googleapis.com/"
      : F.appFlavor == Flavor.stg
          ? "https://www.stg-googleapis.com/"
          : F.appFlavor == Flavor.dev
              ? "https://www.dev-googleapis.com/"
              : "https://www.googleapis.com/";

  static String books = "${baseUrl}books/v1/volumes";
  static String hostUrl = "https://www.google.com";

  static String testImgUrl({num ratio = 1}) {
    int width = Random().nextInt(2160) + 512;
    int height = (width / ratio).toInt();
    return "https://picsum.photos/$width/$height.jpg";
  }
}
