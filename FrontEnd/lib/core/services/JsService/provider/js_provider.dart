import 'package:dbnus/shared/extensions/logger_extension.dart';
import 'package:dbnus/core/services/JsService/helper/js_helper.dart';

class JsProvider {
  static final JSHelper jsHelper = JSHelper();

  // Future getCurrentUrlElementByIdFun(String iframeId) async {
  //   return await jsHelper.getCurrentUrlElementByIdFun(iframeId);
  // }

  // String getPlatformFromJS() {
  //   return jsHelper.getPlatformFromJS();
  // }

  // String getBaseUrlFromJS() {
  //   return jsHelper.getBaseUrlFromJS();
  // }

  // Future<String> callOpenTab() async {
  //   return await jsHelper.callOpenTab();
  // }

  // void reDirectToUrl(String reDirectUrl) {
  //   jsHelper.reDirectToUrl(reDirectUrl);
  // }

  // Future<void> setVolume(double volume) async {
  //   await jsHelper.setVolume(volume);
  // }

  static Future<String?> loadJsAndPassValueWithCallbackAsync(
      {required String value}) async {
    String jsPath = "assets/js/test_process_value.js";
    try {
      return await jsHelper.loadJs<String>(
          jsPath: jsPath,
          jsFunctionName: 'processValueWithCallback',
          jsFunctionArgs: [value],
          usePromise: false);
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  static Future<void> changeUrl({required String path}) async {
    try {
      String jsPath = "assets/js/change_url.js";
      await jsHelper.loadJs(
          jsPath: jsPath, jsFunctionName: 'changeUrl', jsFunctionArgs: [path]);
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  static Future<String?> getDeviceId() async {
    String jsPath = "assets/js/device_id.js";
    try {
      return await jsHelper.loadJs<String>(
          jsPath: jsPath,
          jsFunctionName: 'getDeviceIdFunction',
          usePromise: true);
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  static Future<String?> download(
      {required String url,
      required String filename,
      Map<String, dynamic>? headers}) async {
    String jsPath = "assets/js/download.js";
    try {
      return await jsHelper.loadJs<String>(
          jsPath: jsPath,
          jsFunctionName: 'download',
          jsFunctionArgs: [url, filename, headers]);
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  static Future paytm(
      {required String txnToken,
      required String orderId,
      required String amount,
      required String mid}) async {
    try {
      String jsPath = "assets/js/paytm.js";
      await jsHelper.loadJs(
          jsPath: jsPath,
          jsFunctionName: 'paytm',
          jsFunctionArgs: [txnToken, orderId, amount, mid],
          usePromise: true);
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  static Future<void> submitForm(
      {required String actionUrl,
      required String obj,
      required String id}) async {
    try {
      String jsPath = "assets/js/submit_form.js";
      await jsHelper.loadJs(
          jsPath: jsPath,
          jsFunctionName: 'submitFormFunction',
          jsFunctionArgs: [actionUrl, obj, id]);
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  Future<String?> getWebOtp() async {
    String jsPath = "assets/js/webotp.js";
    try {
      return await jsHelper.loadJs<String>(
          jsPath: jsPath,
          jsFunctionName: 'getOtpCodeFunction',
          usePromise: true);
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  static Future<void> loadJs({required String jsPath, String? id}) async {
    try {
      await jsHelper.loadJs(jsPath: jsPath, id: id);
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  Future<String?> getSessionStorageItem(String key) async {
    try {
      String jsPath = "assets/js/storage-utils.js";
      final result = await jsHelper.loadJs<String>(
        jsPath: jsPath,
        jsFunctionName: 'getSessionStorageItem',
        jsFunctionArgs: [key],
        usePromise: true,
      );
      return result;
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  Future<bool?> clearSessionStorageKey(String key) async {
    try {
      String jsPath = "assets/js/storage-utils.js";
      final result = await jsHelper.loadJs<bool>(
        jsPath: jsPath,
        jsFunctionName: 'clearSessionStorageKey',
        jsFunctionArgs: [key],
        usePromise: true,
      );
      return result;
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  static String getUserAgent() {
    return jsHelper.getUserAgent();
  }

  static bool isMobile() {
    return jsHelper.isMobile();
  }

  /// ```
  ///
  /// {
  ///  "platform": "ios",
  ///  "isInstalled": false,
  ///  "canInstall": false,
  ///  "showIOSInstructions": true,
  ///  "iosInstructions": {
  ///    "step1": "...",
  ///    "step2": "...",
  ///    "step3": "..."
  ///  }
  ///}
  ///
  /// ```
  static Future<String?> getPWAStatus() async {
    try {
      String jsPath = "assets/js/pwa.js";
      final result = await jsHelper.loadJs<String>(
        jsPath: jsPath,
        jsFunctionName: 'getPWAStatus',
        usePromise: true,
      );
      return result;
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  static Future<bool?> installPWA() async {
    try {
      String jsPath = "assets/js/pwa.js";
      final result = await jsHelper.loadJs<bool>(
        jsPath: jsPath,
        jsFunctionName: 'promptInstall',
        usePromise: true,
      );
      return result;
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }
}
