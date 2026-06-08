class ApiConfig {
  static const String baseUrl = 'https://www.googleapis.com/';
  static const String booksEndpoint = '${baseUrl}books/v1/volumes';
  static const String hostUrl = 'https://dbnus-df986.web.app';

  static String testImageUrl({double aspectRatio = 1.0}) {
    final width = 512 + (DateTime.now().millisecondsSinceEpoch % 1648);
    final height = (width / aspectRatio).toInt();
    return 'https://picsum.photos/$width/$height.jpg';
  }
}
