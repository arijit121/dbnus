import 'package:flutter/material.dart';

import 'package:dbnus/navigation/custom_router/custom_route.dart';
import 'package:dbnus/navigation/router_name.dart';
import 'package:dbnus/core/services/value_handler.dart';
import 'package:dbnus/shared/ui/atoms/indicators/loading_widget.dart';
import 'package:dbnus/features/payment_gateway/data/models/web_view_payment_gateway_model.dart';
import 'package:dbnus/features/payment_gateway/data/datasources/local/web_view_payment_gateway_preference.dart';

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
      CustomRoute.clearAndNavigateName(RouteName.initialView);
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
