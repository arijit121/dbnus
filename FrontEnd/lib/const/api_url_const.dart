class ApiUrlConst {
  static bool isLive = true;
  static String baseUrl = isLive
      ? "https://www.googleapis.com/"
      : "https://www.stg-googleapis.com/";

  static String books = "${baseUrl}books/v1/volumes";

  static String reverseGeocode = "https://nominatim.openstreetmap.org/reverse";

  static String hostUrl = "https://www.stg-googleapis.com/";
}
