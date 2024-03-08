import 'dart:js' as js;

import 'package:js/js_util.dart';

import '../library/js_library.dart';

class JSHelper {
  Future paytmLoadScript(
    String txnToken,
    String orderId,
    String amount,
    String mid,
  ) async {
    return await promiseToFuture(onScriptLoad(
      txnToken,
      orderId,
      amount,
      mid,
    ));
  }

  Future<void> downloadFile({required String url, required String name}) async {
    await download(url, name);
  }

  Future<void> changeUrlJs({required String path}) async {
    await changeUrl(path);
  }

  Future<void> onCheckoutPhonePe() async {
    await onCheckoutPhonePeClick();
  }

  Future getCurrentUrlElementByIdFun(String iframeId) async {
    return await promiseToFuture(getCrtUrlElementByIdFun(iframeId));
  }

  String getPlatformFromJS() {
    return js.context.callMethod('getPlatform');
  }

  String getBaseUrlFromJS() {
    return js.context.callMethod('getBaseUrl');
  }

  Future<String> callJSPromise() async {
    return await promiseToFuture(jsPromiseFunction("I am back from JS"));
  }

  Future<String?> getDeviceId() async {
    return await promiseToFuture(getDeviceIdFunction());
  }

  Future<String> callOpenTab() async {
    return await promiseToFuture(jsOpenTabFunction('https://google.com/'));
  }

  void reDirectToUrl(String reDirectUrl) {
    reDirectToUrlFunction(reDirectUrl);
  }

  Future<void> setVolume(double volume) async {
    await setVolumeFunction(volume);
  }

  void submitForm(actionUrl, String obj, String id) {
    submitFormFunction(actionUrl, obj, id);
  }
}
