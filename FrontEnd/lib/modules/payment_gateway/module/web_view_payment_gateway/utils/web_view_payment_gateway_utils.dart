import 'package:flutter/material.dart';

import '../../../../../service/context_service.dart';
import '../../../../../service/value_handler.dart';
import '../model/web_view_payment_gateway_model.dart';

class WebViewPaymentGatewayUtils {
  void onUrlChange(
      {required String uri,
      bool? flagError,
      required WebViewPaymentGatewayModel webViewPaymentGatewayModel}) {
    if (uri.contains(webViewPaymentGatewayModel.redirectLink)) {
      Navigator.of(CurrentContext().context)
          .pop({"PayMent_STATUS": "TXN_SUCCESS"});
    } else if (ValueHandler().isTextNotEmptyOrNull(
            webViewPaymentGatewayModel.failedRedirectLink) &&
        uri.contains(webViewPaymentGatewayModel.failedRedirectLink ?? "")) {
      Navigator.of(CurrentContext().context)
          .pop({"PayMent_STATUS": "TXN_FAILED"});
    } else if (flagError == true) {
      Navigator.of(CurrentContext().context)
          .pop({"PayMent_STATUS": "TXN_ERROR"});
    }
  }
}
