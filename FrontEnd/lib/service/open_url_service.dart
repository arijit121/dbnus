import 'package:genu/extension/logger_extension.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenUrlService {
  void openWhatsApp({required String contactNo, String? message}) {
    try {
      Uri whatsAppUrl = Uri.parse('https://wa.me/$contactNo')
          .replace(queryParameters: message != null ? {"text": message} : null);
      openUrl(uri: whatsAppUrl, mode: LaunchMode.externalApplication);
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  void callNumber({
    required String contactNo,
  }) {
    try {
      Uri callUrl = Uri(scheme: 'tel', path: contactNo);
      openUrl(uri: callUrl, mode: LaunchMode.externalApplication);
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  Future<void> openUrl(
      {required Uri uri, LaunchMode mode = LaunchMode.platformDefault}) async {
    try {
      AppLog.i("OpenUrl==> $uri");
      await launchUrl(uri, mode: mode);
    } catch (e) {
      AppLog.e('Could not launch $uri', error: e);
    }
  }

  Future<void> requestReview() async {
    try {
      final InAppReview inAppReview = InAppReview.instance;
      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
      }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }
}
