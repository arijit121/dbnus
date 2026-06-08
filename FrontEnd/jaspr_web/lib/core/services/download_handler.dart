import 'dart:async';
import 'package:universal_web/web.dart' as web;
import '../../shared/extensions/logger_extension.dart';

class DownloadHandler {
  static Future<void> download({
    required String downloadUrl,
    String? fileName,
    bool? inGroup,
    Map<String, String>? headers,
    Map<String, String>? urlQueryParameters,
  }) async {
    try {
      Uri uri = urlQueryParameters?.isNotEmpty == true
          ? Uri.parse(downloadUrl).replace(queryParameters: urlQueryParameters)
          : Uri.parse(downloadUrl);

      final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
      anchor.href = uri.toString();
      anchor.target = '_blank';
      anchor.download = fileName ?? downloadUrl.split("/").last;
      web.document.body?.appendChild(anchor);
      anchor.click();
      web.document.body?.removeChild(anchor);
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  Future<void> config() async {
    // Web config placeholder
  }
}
