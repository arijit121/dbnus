import '../../../extension/logger_extension.dart';
import '../helper/js_helper.dart';

class JsProvider {
  JSHelper jsHelper = JSHelper();

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

  Future<String?> loadJsAndPassValueWithCallbackAsync(
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

  Future<void> changeUrl({required String path}) async {
    try {
      String jsPath = "assets/js/change_url.js";
      await jsHelper.loadJs(
          jsPath: jsPath, jsFunctionName: 'changeUrl', jsFunctionArgs: [path]);
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  Future<String?> getDeviceId() async {
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

  Future<void> downloadFile({required String url, required String name}) async {
    try {
      String jsPath = "assets/js/download.js";
      await jsHelper.loadJs(
          jsPath: jsPath,
          jsFunctionName: 'download',
          jsFunctionArgs: [url, name]);
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  Future paytm(
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

  Future<void> submitForm(
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

  Future<void> loadJs({required String jsPath}) async {
    try {
      await jsHelper.loadJs(jsPath: jsPath);
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }
}
