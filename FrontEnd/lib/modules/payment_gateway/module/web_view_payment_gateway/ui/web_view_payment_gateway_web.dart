import 'package:flutter/material.dart';
import '../../../../../router/custom_router/web/custom_router_web.dart';
import '../../../../../widget/loading_widget.dart';
import '../model/web_view_payment_gateway_model.dart';
import '../web_view_payment_gateway_preference/web_view_payment_gateway_preference.dart';

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
      WebViewPaymentGatewayPreference()
          .set(widget.webViewPaymentGatewayModel)
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
