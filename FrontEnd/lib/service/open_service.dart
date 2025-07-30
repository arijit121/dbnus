import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart' deferred as in_app_review;
import 'package:open_file/open_file.dart' deferred as open_file;
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../extension/logger_extension.dart';
import '../widget/pdf_viewer_widget.dart' deferred as pdf_viewer_widget;
import 'context_service.dart';

class OpenService {
  static void openWhatsApp({required String contactNo, String? message}) {
    try {
      Uri whatsAppUrl = Uri.parse('https://wa.me/$contactNo')
          .replace(queryParameters: message != null ? {"text": message} : null);
      openUrl(uri: whatsAppUrl, mode: LaunchMode.externalApplication);
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  static void callNumber({required String contactNo}) {
    try {
      Uri callUrl = Uri(scheme: 'tel', path: contactNo);
      openUrl(uri: callUrl, mode: LaunchMode.externalApplication);
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  Future<void> sendEmail(
      {required String toEmail, String? subject, String? body}) async {
    try {
      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: toEmail,
        queryParameters: {'subject': subject, 'body': body},
      );
      await openUrl(uri: emailLaunchUri, mode: LaunchMode.externalApplication);
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  static Future<bool?> openUrl(
      {required Uri uri, LaunchMode mode = LaunchMode.platformDefault}) async {
    try {
      AppLog.i("OpenUrl==> $uri");
      return await launchUrl(uri, mode: mode);
    } catch (e) {
      AppLog.e('Could not launch $uri', error: e);
    }
    return null;
  }

  static Future<void> requestReview() async {
    try {
      await in_app_review.loadLibrary();
      final inAppReview = in_app_review.InAppReview.instance;
      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
      }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  static Future<void> openFile(String filePath) async {
    await open_file.loadLibrary();
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
    await Permission.accessMediaLocation.request();
    await open_file.OpenFile.open(filePath);
  }

  static Future<ShareResultStatus> share({required String text}) async {
    final result = await Share.share(text);
    return result.status;
  }

  static Future<void> openAddressInMap(
      {required String address, bool? direction}) async {
    String url = direction == true
        ? "https://www.google.com/maps/dir/?api=1&layer=traffic&destination=$address"
        : "https://www.google.com/maps/search/?api=1&query=$address";
    await openUrl(
      uri: Uri.parse(url),
    );
  }

  static Future<void> openCoordinatesInMap(
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

  static Future<void> openPdf(
      {required String pdfUrl,
      String? title,
      Map<String, String>? headers}) async {
    await pdf_viewer_widget.loadLibrary();
    Navigator.push(
      CurrentContext().context,
      MaterialPageRoute(
        builder: (context) => pdf_viewer_widget.PdfViewerWidget(
          pdfUrl: pdfUrl,
          title: title,
          headers: headers,
        ),
      ),
    );
  }
}
