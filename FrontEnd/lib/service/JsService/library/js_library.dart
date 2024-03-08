@JS()
library script.js;

import 'package:js/js.dart';

@JS()
external dynamic onScriptLoad(
    String txnToken, String orderId, String amount, String mid);

@JS()
external dynamic webEngageLogin(String userId);

@JS()
external dynamic webEngageLogout();

@JS()
external dynamic webEngageSetAttribute(String key, var value);

@JS()
external dynamic webEngageTrack(
    String eventName, Map<String, dynamic>? eventData);

@JS()
external dynamic download(String url, String name);

@JS()
external dynamic changeUrl(String path);

@JS()
external dynamic onCheckoutPhonePeClick();

@JS()
external dynamic getCrtUrlElementByIdFun(String iframeId);

@JS()
external dynamic jsPromiseFunction(String message);

@JS()
external dynamic getDeviceIdFunction();

@JS()
external dynamic jsOpenTabFunction(String url);

@JS()
external dynamic reDirectToUrlFunction(String url);

@JS()
external dynamic setVolumeFunction(double volume);

@JS()
external dynamic submitFormFunction(String actionUrl, String objStr, String id);

///         ^            ^                ^
///      return     functionName       arguments
