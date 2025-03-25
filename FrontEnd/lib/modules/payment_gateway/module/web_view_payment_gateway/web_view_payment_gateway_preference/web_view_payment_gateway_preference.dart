import 'dart:convert';

import '../../../../../storage/local_preferences.dart'
    deferred as local_preferences;
import '../model/web_view_payment_gateway_model.dart';

class WebViewPaymentGatewayPreference {
  Future<void> set(
      WebViewPaymentGatewayModel webViewPaymentGatewayModel) async {
    await local_preferences.loadLibrary();
    await local_preferences.LocalPreferences().setString(
        key: local_preferences.LocalPreferences.webTryCatchPaymentData,
        value: json.encode(webViewPaymentGatewayModel.toJson()));
  }

  Future<WebViewPaymentGatewayModel> get() async {
    await local_preferences.loadLibrary();
    return WebViewPaymentGatewayModel.fromJson(
      json.decode(await local_preferences.LocalPreferences().getString(
              key: local_preferences.LocalPreferences.webTryCatchPaymentData) ??
          ""),
    );
  }

  Future<void> clear() async {
    await local_preferences.loadLibrary();
    await local_preferences.LocalPreferences().clearKey(
        key: local_preferences.LocalPreferences.webTryCatchPaymentData);
  }
}
