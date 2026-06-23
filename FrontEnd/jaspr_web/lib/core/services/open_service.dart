import 'package:universal_web/js_interop.dart';
import 'package:universal_web/web.dart' as web;
import '../../shared/extensions/logger_extension.dart';

class OpenService {
  static void openWhatsApp({required String contactNo, String? message}) {
    try {
      Uri whatsAppUrl = Uri.parse('https://wa.me/$contactNo')
          .replace(queryParameters: message != null ? {"text": message} : null);
      openUrl(uri: whatsAppUrl);
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  static void callNumber({required String contactNo}) {
    try {
      Uri callUrl = Uri(scheme: 'tel', path: contactNo);
      openUrl(uri: callUrl);
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  static Future<void> sendEmail({
    required String toEmail,
    String? subject,
    String? body,
  }) async {
    try {
      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: toEmail,
        queryParameters: {
          if (subject != null) 'subject': subject,
          if (body != null) 'body': body,
        },
      );
      await openUrl(uri: emailLaunchUri);
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  static Future<bool?> openUrl({required Uri uri}) async {
    try {
      AppLog.i("OpenUrl==> $uri");
      web.window.open(uri.toString(), '_blank');
      return true;
    } catch (e) {
      AppLog.e('Could not launch $uri', error: e);
    }
    return false;
  }

  static Future<void> requestReview() async {
    AppLog.i("Review requested (web placeholder)");
  }

  static Future<void> openFile(String filePath) async {
    AppLog.i("OpenFile requested for path: $filePath");
  }

  static Future<String> share({required String title, required String text, required String url}) async {
    try {
      final navigator = web.window.navigator;
      // Check if Web Share API is supported
      if (hasShare(navigator)) {
        final shareData = {
          'title': title,
          'text': text,
          'url': url,
        }.jsify();
        
        // Call share
        final promise = (navigator as dynamic).share(shareData) as JSPromise;
        await promise.toDart;
        return "success";
      } else {
        AppLog.w("Web Share API is not supported on this browser.");
      }
    } catch (e) {
      AppLog.e("Error sharing: $e");
    }
    return "failed";
  }

  static bool hasShare(web.Navigator navigator) {
    return (navigator as dynamic).share != null;
  }

  static Future<void> openAddressInMap({required String address, bool? direction}) async {
    String url = direction == true
        ? "https://www.google.com/maps/dir/?api=1&layer=traffic&destination=${Uri.encodeComponent(address)}"
        : "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}";
    await openUrl(uri: Uri.parse(url));
  }

  static Future<void> openCoordinatesInMap({
    required double latitude,
    required double longitude,
    bool? direction,
  }) async {
    String url = direction == true
        ? "https://www.google.com/maps/dir/?api=1&layer=traffic&destination=$latitude,$longitude"
        : "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
    await openUrl(uri: Uri.parse(url));
  }

  static Future<void> openPdf({
    required String pdfUrl,
    String? title,
    Map<String, String>? headers,
  }) async {
    // On the web, we can simply open the PDF in a new tab
    await openUrl(uri: Uri.parse(pdfUrl));
  }
}
