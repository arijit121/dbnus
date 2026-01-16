import 'package:flutter/material.dart';

import 'package:dbnus/navigation/custom_router/web/custom_router_web.dart';
import 'package:dbnus/shared/ui/atoms/indicators/loading_widget.dart';
import 'package:dbnus/features/payment_gateway/module/web_view_payment_gateway/model/web_view_payment_gateway_model.dart';
import 'package:dbnus/features/payment_gateway/module/web_view_payment_gateway/web_view_payment_gateway_preference/web_view_payment_gateway_preference.dart';

class WebViewPaymentGateway extends StatefulWidget {
  const WebViewPaymentGateway(
      {super.key, required this.webViewPaymentGatewayModel});

  final WebViewPaymentGatewayModel webViewPaymentGatewayModel;

  @override
  State<WebViewPaymentGateway> createState() => _WebViewPaymentGatewayState();
}

class _WebViewPaymentGatewayState extends State<WebViewPaymentGateway> {
  @override
  void initState() {
    start();
    super.initState();
  }

  Future<void> start() async {
    await Future.wait([
      WebViewPaymentGatewayPreference().set(widget.webViewPaymentGatewayModel)
    ]);
    CustomRouterWeb().reDirect(widget.webViewPaymentGatewayModel.paymentLink);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: LoadingWidget()),
    );
  }
}
