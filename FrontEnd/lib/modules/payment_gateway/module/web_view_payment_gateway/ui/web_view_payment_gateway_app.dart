import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../const/color_const.dart';
import '../../../../../extension/logger_extension.dart';
import '../../../../../service/open_service.dart';
import '../../../../../service/value_handler.dart';
import '../../../../../utils/pop_up_items.dart';
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
            if (uri.startsWith("upi://pay")) {
              bool? result = await OpenService.openUrl(
                  uri: Uri.parse(uri), mode: LaunchMode.externalApplication);
              if (result != true) {
                PopUpItems.toastMessage(
                    "Looks like there’s no UPI app available on your device.",
                    ColorConst.red);
              }
              return NavigationActionPolicy.CANCEL;
            } else if (!uri.startsWith("http")) {
              bool? result = await OpenService.openUrl(
                  uri: Uri.parse(uri), mode: LaunchMode.externalApplication);
              if (result != true) {
                PopUpItems.toastMessage(
                    "Couldn’t open the requested app. Please try again or install a supported application.",
                    ColorConst.red);
              }
              return NavigationActionPolicy.CANCEL;
            }

            return NavigationActionPolicy.ALLOW;
          },
          onUpdateVisitedHistory: (controller, uri, isReload) {
            AppLog.i(uri, tag: "OnUpdateVisitedHistory");
            if (ValueHandler.isTextNotEmptyOrNull(uri)) {
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
