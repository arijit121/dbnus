import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../../../../extension/logger_extension.dart';
import '../../../../../service/value_handler.dart';
import '../model/web_view_payment_gateway_model.dart';
import '../utils/web_view_payment_gateway_utils.dart';

class WebViewPaymentGateway extends StatefulWidget {
  const WebViewPaymentGateway(
      {super.key, required this.webViewPaymentGatewayModel});

  final WebViewPaymentGatewayModel webViewPaymentGatewayModel;

  @override
  State<WebViewPaymentGateway> createState() => _WebViewPaymentGatewayState();
}

class _WebViewPaymentGatewayState extends State<WebViewPaymentGateway> {
  InAppWebViewController? _controller;
  Timer? _timer;

  @override
  void initState() {
    if (widget.webViewPaymentGatewayModel.timeOut != null) {
      _timer = Timer(widget.webViewPaymentGatewayModel.timeOut!, () async {
        WebUri? uri = await _controller?.getUrl();
        AppLog.i(uri, tag: "TimeOut");
        if (ValueHandler().isTextNotEmptyOrNull(uri)) {
          AppLog.i(uri, tag: "UrlChange");
          WebViewPaymentGatewayUtils().onUrlChange(
              uri: uri.toString(),
              flagError: true,
              webViewPaymentGatewayModel: widget.webViewPaymentGatewayModel);
        }
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: InAppWebView(
          initialUrlRequest: URLRequest(
              url: WebUri(widget.webViewPaymentGatewayModel.paymentLink)),
          initialSettings: InAppWebViewSettings(
            clearSessionCache: true,
            clearCache: true,
            cacheEnabled: false,
            javaScriptCanOpenWindowsAutomatically: true,
            javaScriptEnabled: true,
            allowFileAccessFromFileURLs: true,
            allowUniversalAccessFromFileURLs: true,
            domStorageEnabled: true,
            useShouldInterceptRequest: true,
            mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
            // iframeAllow: "web-share API; payment",
            // iframeAllowFullscreen: true,
            // iframeCsp:
            //     "default-src 'self' https://trusted.com; script-src 'self';",
            // iframeSandbox: "allow-same-origin allow-scripts allow-forms",
            // iframeName: "SSPaymentIframe",
            // iframeReferrerPolicy: ReferrerPolicy.NO_REFERRER,
          ),
          onWebViewCreated: (controller) {
            _controller = controller;
          },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            String uri = navigationAction.request.url.toString();
            AppLog.i(uri, tag: "ShouldOverrideUrlLoading");
            return NavigationActionPolicy.ALLOW;
          },
          onUpdateVisitedHistory: (controller, uri, isReload) {
            AppLog.i(uri, tag: "OnUpdateVisitedHistory");
            if (ValueHandler().isTextNotEmptyOrNull(uri)) {
              AppLog.i(uri, tag: "UrlChange");
              WebViewPaymentGatewayUtils().onUrlChange(
                  uri: uri.toString(),
                  webViewPaymentGatewayModel:
                      widget.webViewPaymentGatewayModel);
            }
          },
          onReceivedError: (controller, request, error) {
            AppLog.e(request.toString(), error: error);
          },
        ),
      ),
    );
  }
}
