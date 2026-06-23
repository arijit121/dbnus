import 'dart:js_interop';

@JS('dynamicJsLoader')
external JSPromise<JSAny?> dynamicJsLoader(LoadJsOptions options);

@JS()
@anonymous
extension type LoadJsOptions._(JSObject _) implements JSObject {
  external factory LoadJsOptions({
    String? jsPath,
    String? id,
    String? jsFunctionName,
    JSArray<JSAny?>? jsFunctionArgs,
    bool? usePromise,
  });
}

// @JS()
// external dynamic example(String actionUrl, String objStr, String id);

///         ^            ^                ^
///      return     functionName       arguments
