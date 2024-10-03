class ApiUrlConst {
  static bool isLive = true;
  static String baseUrl = isLive
      ? "https://www.googleapis.com/"
      : "https://www.stg-googleapis.com/";

  static String books = "${baseUrl}books/v1/volumes";
  static String hostUrl = "https://www.google.com";

  static String testImgUrl = "https://picsum.photos/512/512.jpg";
}
