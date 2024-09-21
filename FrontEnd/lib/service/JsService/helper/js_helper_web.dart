import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:js_util' as js_util;

import '../library/js_library.dart';
import 'dart:async';

class JSHelper {
  Future paytmLoadScript(
    String txnToken,
    String orderId,
    String amount,
    String mid,
  ) async {
    return await js_util.promiseToFuture(onScriptLoad(
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
    return await js_util.promiseToFuture(getCrtUrlElementByIdFun(iframeId));
  }

  String getPlatformFromJS() {
    return js.context.callMethod('getPlatform');
  }

  String getBaseUrlFromJS() {
    return js.context.callMethod('getBaseUrl');
  }

  Future<String> callJSPromise() async {
    return await js_util
        .promiseToFuture(jsPromiseFunction("I am back from JS"));
  }

  Future<String?> getDeviceId() async {
    return await js_util.promiseToFuture(getDeviceIdFunction());
  }

  Future<String> callOpenTab() async {
    return await js_util
        .promiseToFuture(jsOpenTabFunction('https://google.com/'));
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

// Function to dynamically load JS and pass value with async/await
  Future<String?> loadJsAndPassValueWithCallbackAsync(
      {required String value}) async {
    // Create a completer to manage async operation
    final completer = Completer<String>();

    // Check if the JS script is already loaded
    if (html.document.querySelector('script[src="assets/js/custom.js"]') ==
        null) {
      // Create a script element
      final script = html.ScriptElement()
        ..type = 'application/javascript'
        ..src = 'assets/js/custom.js';

      // Append the script to the document head
      html.document.head!.append(script);

      // Wait for the script to load
      await script.onLoad.first;

      // Call the JS function and pass the value and Dart callback
      js.context.callMethod('processValueAndCallback', [
        value,
        js.allowInterop((result) {
          // Complete the future with the result when the callback is called
          completer.complete(result);
        })
      ]);

      // Handle script load errors
      script.onError.listen((event) {
        completer.completeError('Error loading JavaScript file');
      });
    } else {
      // If the script is already loaded, just call the JS function with value and callback
      js.context.callMethod('processValueAndCallback', [
        value,
        js.allowInterop((result) {
          // Complete the future with the result when the callback is called
          completer.complete(result);
        })
      ]);
    }

    // Return the result when the completer completes
    return completer.future;
  }
}
