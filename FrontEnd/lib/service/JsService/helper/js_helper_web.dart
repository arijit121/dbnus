import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:js_util' as js_util;

// import '../library/js_library.dart';
import 'dart:async';
import '../../../extension/logger_extension.dart';

class JSHelper {
  // Future paytmLoadScript(
  //   String txnToken,
  //   String orderId,
  //   String amount,
  //   String mid,
  // ) async {
  //   return await js_util.promiseToFuture(onScriptLoad(
  //     txnToken,
  //     orderId,
  //     amount,
  //     mid,
  //   ));
  // }

  // Future<void> downloadFile({required String url, required String name}) async {
  //   await download(url, name);
  // }

  // Future<void> onCheckoutPhonePe() async {
  //   await onCheckoutPhonePeClick();
  // }

  // Future getCurrentUrlElementByIdFun(String iframeId) async {
  //   return await js_util.promiseToFuture(getCrtUrlElementByIdFun(iframeId));
  // }

  // String getPlatformFromJS() {
  //   return js.context.callMethod('getPlatform');
  // }

  // String getBaseUrlFromJS() {
  //   return js.context.callMethod('getBaseUrl');
  // }

  // Future<String> callJSPromise() async {
  //   return await js_util
  //       .promiseToFuture(jsPromiseFunction("I am back from JS"));
  // }

  // Future<String?> getDeviceId() async {
  //   return await js_util.promiseToFuture(getDeviceIdFunction());
  // }

  // Future<String> callOpenTab() async {
  //   return await js_util
  //       .promiseToFuture(jsOpenTabFunction('https://google.com/'));
  // }

  // void reDirectToUrl(String reDirectUrl) {
  //   reDirectToUrlFunction(reDirectUrl);
  // }

  // Future<void> setVolume(double volume) async {
  //   await setVolumeFunction(volume);
  // }

  // void submitForm(actionUrl, String obj, String id) {
  //   submitFormFunction(actionUrl, obj, id);
  // }

  /// ```
  ///
  /// Loads a JavaScript file (if not already loaded) and processes a value using either a Promise-based or callback-based JavaScript function.
  ///
  /// jsFilePath - The jsFilePath is the location of js like "assets/js/change_url.js".
  /// jsFunctionName - The jsFunctionName is the name of function like "processValue".
  /// jsFunctionArgs - The jsFunctionArgs to be processed by the JavaScript function.
  /// usePromise - If true, calls the Promise-based JavaScript function.
  ///              If false, calls the callback-based JavaScript function.
  ///
  /// Example Js:-
  ///
  /// With Promise:
  /// async function processValue(value) {
  /// return new Promise((resolve, reject) => {
  ///   // Simulate some asynchronous processing
  ///    setTimeout(() => {
  ///      const result = `Processed value: ${value}`;
  ///      resolve(result);  // Resolve the promise with the result
  ///    }, 2000);  // Simulated delay (e.g., async operation)
  ///  });
  ///}
  ///
  /// With Out Promise:
  /// function changeUrl(path) {
  ///    history.pushState('', '', path);
  ///}
  ///
  /// ```
  ///
  Future<T?> loadJs<T>({
    required String jsFilePath,
    required String jsFunctionName,
    List<Object?>? jsFunctionArgs,
    bool usePromise = false,
  }) async {
    try {
      // Check if the script is already loaded
      if (html.document.querySelector('script[src="$jsFilePath"]') == null) {
        // Create a script element
        final script = html.ScriptElement()
          ..type = 'application/javascript'
          ..src = jsFilePath;

        // Append the script to the document head
        html.document.head!.append(script);

        // Wait for the script to load or throw an error if it fails
        await script.onLoad.first.catchError((error) {
          throw Exception('Error loading JS script: $error');
        });
      }

      if (usePromise) {
        if (jsFunctionName.isEmpty) {
          throw Exception('JavaScript function name is empty.');
        }

        try {
          // Call the JavaScript function and handle the Promise using `promiseToFuture`
          final promise = js_util.callMethod(
              html.window, jsFunctionName, jsFunctionArgs ?? []);
          if (promise == null) {
            return null; // Handle `null` result from JS function
          }
          return await js_util.promiseToFuture<T>(promise);
        } catch (error) {
          throw Exception('Error calling JS function with Promise: $error');
        }
      } else {
        try {
          final completer = Completer<T?>();

          if (jsFunctionName.isEmpty) {
            throw Exception('JavaScript function name is empty.');
          }

          // Call the JavaScript function and handle null return values
          js.context.callMethod(jsFunctionName, [
            ...(jsFunctionArgs ?? []),
            js.allowInterop((result) {
              // Allow `null` or `undefined` results
              completer.complete(
                  result); // Complete with `null` if JS returns `undefined`
            })
          ]);

          return await completer.future;
        } catch (error) {
          throw Exception('Error calling JS function with callback: $error');
        }
      }
    } catch (error) {
      throw Exception('Unexpected error in loadJs: $error');
    }
  }
}
