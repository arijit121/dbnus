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

  static String testImgUrl = "https://picsum.photos/512/512.jpg";
}
