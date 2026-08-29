import 'package:universal_web/js_interop.dart';

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
