import 'package:flutter/material.dart';

import '../../../../../router/custom_router/custom_route.dart';
import '../../../../../router/router_name.dart';
import '../../../../../service/value_handler.dart';
import '../../../../../widget/loading_widget.dart';
import '../model/web_view_payment_gateway_model.dart';
import '../web_view_payment_gateway_preference/web_view_payment_gateway_preference.dart';

class WebViewPaymentGatewayStatus extends StatefulWidget {
  const WebViewPaymentGatewayStatus({super.key});

  @override
  State<WebViewPaymentGatewayStatus> createState() =>
      _WebViewPaymentGatewayStatusState();
}

class _WebViewPaymentGatewayStatusState
    extends State<WebViewPaymentGatewayStatus> {
  @override
  void initState() {
    start();
    super.initState();
  }

  Future<void> start() async {
    WebViewPaymentGatewayModel webViewPaymentGatewayModel =
        await WebViewPaymentGatewayPreference().get();
    if (ValueHandler.isTextNotEmptyOrNull(
        webViewPaymentGatewayModel.transactionId)) {
      // Call for success
    } else {
      CustomRoute.clearAndNavigate(RouteName.initialView);
    }
    await WebViewPaymentGatewayPreference().clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: LoadingWidget()),
    );
  }
}
