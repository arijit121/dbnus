import 'package:in_app_review/in_app_review.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../extension/logger_extension.dart';

class OpenService {
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
      AppLog.i("$uri", tag: "OpenUrl");
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

  Future<void> openFile(String filePath) async {
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
    await Permission.accessMediaLocation.request();
    await OpenFile.open(filePath);
  }

  Future<ShareResultStatus> share({required String text}) async {
    final result = await Share.share(text);
    return result.status;
  }

  Future<void> openAddressInMap(
      {required String address, bool? direction}) async {
    String url = direction == true
        ? "https://www.google.com/maps/dir/?api=1&layer=traffic&destination=$address"
        : "https://www.google.com/maps/search/?api=1&query=$address";
    await openUrl(
      uri: Uri.parse(url),
    );
  }

  Future<void> openCoordinatesInMap(
      {required double latitude,
      required double longitude,
      bool? direction}) async {
    String url = direction == true
        ? "https://www.google.com/maps/dir/?api=1&layer=traffic&destination=$latitude,$longitude"
        : "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
    await openUrl(
      uri: Uri.parse(url),
    );
  }
}
