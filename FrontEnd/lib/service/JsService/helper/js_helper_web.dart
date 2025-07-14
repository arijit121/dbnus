import 'dart:async';
import '../library/js_library.dart';
// import 'dart:js' deferred as js;
// import 'dart:js_util' deferred as js_util;
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:web/web.dart' as web;
import 'package:flutter/foundation.dart';
// import '../../value_handler.dart';

class JSHelper {
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
  /* Future<T?> loadJs<T>(
      {String? jsPath,
      String? id,
      String? jsFunctionName,
      List<Object?>? jsFunctionArgs,
      bool usePromise = false}) async {
    try {
      await Future.wait([js.loadLibrary(), js_util.loadLibrary()]);
      if ((jsPath == null || jsPath.isEmpty) &&
          (jsFunctionName == null || jsFunctionName.isEmpty)) {
        throw Exception(
            "Both jsPath and jsFunctionName can't be null or empty. Atleast pass one value.");
      }

      if (jsPath != null && jsPath.isNotEmpty) {
        String _jsFilePath;
        if (kReleaseMode &&
            !jsPath.contains("https://") &&
            !jsPath.contains("http://")) {
          _jsFilePath = "assets/${jsPath ?? ""}";
          final flutterAssetBase =
              js_util.getProperty(web.window, 'flutterAssetBase');
          if (flutterAssetBase is String) {
            _jsFilePath = flutterAssetBase + _jsFilePath;
          }
        } else {
          _jsFilePath = jsPath ?? "";
        }

        // Check if the script is already loaded
        if (web.document.querySelector('script[src="$_jsFilePath"]') == null) {
          // Create a script element
          final script = web.HTMLScriptElement()
            ..type = 'application/javascript'
            ..src = _jsFilePath;

          if (ValueHandler.isTextNotEmptyOrNull(id)) {
            script.id = id!;
          }
          // Append the script to the document head
          web.document.head!.append(script);

          // Wait for the script to load or throw an error if it fails
          await script.onLoad.first.catchError((error) {
            throw Exception('Error loading JS script: $error');
          });
        }
      }
      if (jsFunctionName != null && jsFunctionName.isNotEmpty) {
        if (usePromise) {
          if (jsFunctionName.isEmpty) {
            throw Exception('JavaScript function name is empty.');
          }

          try {
            // Call the JavaScript function and handle the Promise using `promiseToFuture`
            final promise = js_util.callMethod(
                web.window, jsFunctionName, jsFunctionArgs ?? []);
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
      }
    } catch (error) {
      throw Exception(
          'Unexpected error in ${jsPath == null || !(jsPath?.isNotEmpty == true) ? "loadJs : Your pass jsPath null or blank please check the jsPath or import the js inside head of index.html." : ":"} $error');
    }
    return null;
  }*/

  Future<T?> loadJs<T>({
    String? jsPath,
    String? id,
    String? jsFunctionName,
    List<Object?>? jsFunctionArgs,
    bool usePromise = false,
  }) async {
    try {
      final jsArgs = jsFunctionArgs?.map((arg) => arg?.jsify()).toList().toJS;
      String? _jsFilePath;
      if (jsPath != null && jsPath.isNotEmpty) {
        if (kReleaseMode &&
            !jsPath.contains("https://") &&
            !jsPath.contains("http://")) {
          _jsFilePath = "assets/${jsPath ?? ""}";
        } else {
          _jsFilePath = jsPath ?? "";
        }
      }

      final options = LoadJsOptions(
        jsPath: _jsFilePath,
        id: id,
        jsFunctionName: jsFunctionName,
        jsFunctionArgs: jsArgs,
        usePromise: usePromise,
      );

      final result = await dynamicJsLoader(options).toDart;
      return result?.dartify() as T?;
    } catch (e) {
      throw Exception('Error calling loadJs: $e');
    }
  }

  String getUserAgent() {
    return web.window.navigator.userAgent;
  }
}
