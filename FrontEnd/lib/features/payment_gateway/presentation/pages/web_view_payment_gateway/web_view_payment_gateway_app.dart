import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/logger_extension.dart';
import 'package:dbnus/core/services/context_service.dart';
import 'package:dbnus/core/services/open_service.dart';
import 'package:dbnus/core/services/value_handler.dart';
import 'package:dbnus/shared/utils/pop_up_items.dart';
import 'package:dbnus/shared/ui/atoms/buttons/custom_button.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:dbnus/features/payment_gateway/data/models/web_view_payment_gateway_model.dart';

class WebViewPaymentGateway extends StatelessWidget {
  const WebViewPaymentGateway(
      {super.key, required this.webViewPaymentGatewayModel});

  final WebViewPaymentGatewayModel webViewPaymentGatewayModel;

  @override
  Widget build(BuildContext context) {
    return InAppWebViewPaymentGateway(
      webViewPaymentGatewayModel: webViewPaymentGatewayModel,
    );
  }
}

class InAppWebViewPaymentGateway extends StatefulWidget {
  const InAppWebViewPaymentGateway(
      {super.key, required this.webViewPaymentGatewayModel});

  final WebViewPaymentGatewayModel webViewPaymentGatewayModel;

  @override
  State<InAppWebViewPaymentGateway> createState() =>
      _InAppWebViewPaymentGatewayState();
}

class _InAppWebViewPaymentGatewayState
    extends State<InAppWebViewPaymentGateway> {
  InAppWebViewController? _controller;

  void _onUrlChange(
      {required String uri,
      bool? flagError,
      required WebViewPaymentGatewayModel webViewPaymentGatewayModel}) {
    if (uri.contains(webViewPaymentGatewayModel.redirectLink)) {
      Navigator.of(CurrentContext().context)
          .pop({"PayMent_STATUS": "TXN_SUCCESS"});
    } else if (ValueHandler.isTextNotEmptyOrNull(
            webViewPaymentGatewayModel.failedRedirectLink) &&
        uri.contains(webViewPaymentGatewayModel.failedRedirectLink ?? "")) {
      Navigator.of(CurrentContext().context)
          .pop({"PayMent_STATUS": "TXN_FAILED"});
    } else if (flagError == true) {
      Navigator.of(CurrentContext().context)
          .pop({"PayMent_STATUS": "TXN_ERROR"});
    }
  }

  Future<void> _handleExternalApp(String uri) async {
    try {
      bool? result = await OpenService.openUrl(
          uri: Uri.parse(uri), mode: LaunchMode.externalApplication);
      if (result != true) {
        PopUpItems.toastMessage(
            uri.contains("upi://pay")
                ? "Looks like there's no UPI app available on your device."
                : "Couldn't open the requested app. Please try again or install a supported application.",
            ColorConst.red);
      }
    } catch (e) {
      AppLog.e(e.toString(), error: e, tag: "External App Error");
      PopUpItems.toastMessage(
          uri.contains("upi://pay")
              ? "Failed to open UPI app. Please try again."
              : "Failed to open external app. Please try again.",
          ColorConst.red);
    }
  }

  Future<bool> _onWillPop() async {
    if (await _controller?.canGoBack() == true) {
      await _controller?.goBack();
      return false;
    }
    bool isCancel = false;
    await PopUpItems.materialPopup(
        title: "Exit Payment",
        content: "Are you sure you want to exit the payment process?",
        cancelBtnPresses: () {
          isCancel = false;
        },
        okBtnPressed: () {
          isCancel = true;
        });
    return isCancel;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, val) async {
          if (didPop) return; // system back already handled
          bool shouldPop = await _onWillPop();
          if (context.mounted && shouldPop) {
            Navigator.pop(context);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: CustomIconButton(
              onPressed: () async {
                bool shouldPop = await _onWillPop();
                if (context.mounted && shouldPop) {
                  Navigator.pop(context);
                }
              },
              icon: const Icon(Icons.arrow_back_sharp),
              color: ColorConst.primaryDark,
            ),
            title: CustomTextEnum(
              widget.webViewPaymentGatewayModel.title ?? "Payment Gateway",
              color: ColorConst.primaryDark,
              styleType: CustomTextStyleType.subHeading3,
            ),
          ),
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
                // checkoutUpiIntent channel (Android)
                controller.addJavaScriptHandler(
                  handlerName: "checkoutUpiIntent",
                  callback: (args) {
                    if (args.isNotEmpty) {
                      final url = args.first.toString();
                      AppLog.i("JS called checkoutUpiIntent with $url",
                          tag: "JSChannel");
                      _handleExternalApp(url);
                    }
                    return {"status": "ok"};
                  },
                );

                // sendSignalToNative channel (iOS)
                controller.addJavaScriptHandler(
                  handlerName: "sendSignalToNative",
                  callback: (args) {
                    try {
                      if (args.isEmpty) {
                        return {"status": "error", "message": "No data"};
                      }

                      final data = args.first.toString();
                      AppLog.i("Received from JS: $data", tag: "JSChannel");

                      final decoded = jsonDecode(data);

                      if (decoded["message"] == "Invoke PSP app") {
                        final deeplink = decoded["deeplink"];
                        if (deeplink != null) {
                          _handleExternalApp(deeplink);
                        }
                      }
                      return {"status": "ok"};
                    } catch (e) {
                      AppLog.e("JSChannel parsing error", error: e);
                      return {"status": "error", "message": e.toString()};
                    }
                  },
                );
                _controller = controller;
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                String uri = navigationAction.request.url.toString();
                AppLog.i(uri, tag: "ShouldOverrideUrlLoading");
                if (uri.startsWith("upi://pay")) {
                  _handleExternalApp(uri);
                  return NavigationActionPolicy.CANCEL;
                } else if (!uri.startsWith("http") &&
                    !uri.startsWith("about:")) {
                  _handleExternalApp(uri);
                  return NavigationActionPolicy.CANCEL;
                }

                return NavigationActionPolicy.ALLOW;
              },
              onLoadStop: (controller, uri) {
                AppLog.i(uri, tag: "OnLoadStop");
                if (ValueHandler.isTextNotEmptyOrNull(uri)) {
                  AppLog.i(uri, tag: "UrlChange");
                  _onUrlChange(
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
        ));
  }
}

class FlutterWebViewPaymentGateway extends StatefulWidget {
  const FlutterWebViewPaymentGateway(
      {super.key, required this.webViewPaymentGatewayModel});

  final WebViewPaymentGatewayModel webViewPaymentGatewayModel;

  @override
  State<FlutterWebViewPaymentGateway> createState() =>
      _FlutterWebViewPaymentGatewayState();
}

class _FlutterWebViewPaymentGatewayState
    extends State<FlutterWebViewPaymentGateway> {
  late WebViewController _controller;
  bool _isLoading = true;
  String _currentUrl = '';
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'checkoutUpiIntent', // same name as in android docs
        onMessageReceived: (JavaScriptMessage message) {
          final String url = message.message;
          AppLog.i("JS called checkoutUpiIntent with $url", tag: "JSChannel");
          _handleExternalApp(url); // use your existing UPI handler
        },
      )
      ..addJavaScriptChannel(
        'sendSignalToNative', // same name as in iOS docs
        onMessageReceived: (JavaScriptMessage message) {
          try {
            final data = message.message;
            AppLog.i("Received from JS: $data", tag: "JSChannel");

            // If the JS sends JSON, decode it
            final decoded = jsonDecode(data);

            if (decoded["message"] == "Invoke PSP app") {
              final deeplink = decoded["deeplink"];
              if (deeplink != null) {
                _handleExternalApp(deeplink); // your existing Dart handler
              }
            }
          } catch (e) {
            AppLog.e(e.toString(), error: e, tag: "JSChannel parsing error");
          }
        },
      )
      ..setBackgroundColor(const Color(0x00000000))
      ..clearCache()
      ..clearLocalStorage()
      ..setNavigationDelegate(
        NavigationDelegate(onProgress: (int progress) {
          AppLog.i('Loading progress: $progress%', tag: "WebViewProgress");
        }, onPageStarted: (String url) {
          setState(() {
            _isLoading = true;
            _currentUrl = url;
            _hasError = false;
          });
          AppLog.i(url, tag: "PageStarted");
        }, onPageFinished: (String url) {
          setState(() {
            _isLoading = false;
          });
          AppLog.i(url, tag: "OnPageFinished");
          if (ValueHandler.isTextNotEmptyOrNull(url)) {
            AppLog.i(url, tag: "UrlChange");
            _onUrlChange(
                uri: url,
                webViewPaymentGatewayModel: widget.webViewPaymentGatewayModel);
          }
        }, onWebResourceError: (error) {
          setState(() {
            _hasError = true;
            _errorMessage = error.description;
          });
          AppLog.e(error.description, error: error, tag: "WebView Error");
        }, onNavigationRequest: (NavigationRequest request) {
          String uri = request.url;
          AppLog.i(uri, tag: "NavigationRequest");

          return _handleNavigationRequest(uri);
        }, onHttpError: (HttpResponseError error) {
          AppLog.e('${error.response?.statusCode}',
              error: error, tag: "HTTP Error");
        }, onSslAuthError: (SslAuthError error) {
          AppLog.e(error.toString(), error: error, tag: "SslAuth Error");
        }),
      )
      ..setUserAgent(
          'Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36')
      ..loadRequest(Uri.parse(widget.webViewPaymentGatewayModel.paymentLink));
  }

  NavigationDecision _handleNavigationRequest(String uri) {
    if (uri.contains("upi://pay")) {
      _handleExternalApp(uri);
      return NavigationDecision.prevent;
    } else if (!uri.startsWith("http") &&
        !uri.startsWith("https") &&
        !uri.startsWith("about:") &&
        !uri.startsWith("data:")) {
      _handleExternalApp(uri);
      return NavigationDecision.prevent;
    }

    return NavigationDecision.navigate;
  }

  Future<void> _handleExternalApp(String uri) async {
    try {
      bool? result = await OpenService.openUrl(
          uri: Uri.parse(uri), mode: LaunchMode.externalApplication);
      if (result != true) {
        PopUpItems.toastMessage(
            uri.contains("upi://pay")
                ? "Looks like there's no UPI app available on your device."
                : "Couldn't open the requested app. Please try again or install a supported application.",
            ColorConst.red);
      }
    } catch (e) {
      AppLog.e(e.toString(), error: e, tag: "External App Error");
      PopUpItems.toastMessage(
          uri.contains("upi://pay")
              ? "Failed to open UPI app. Please try again."
              : "Failed to open external app. Please try again.",
          ColorConst.red);
    }
  }

  Future<void> _refreshPage() async {
    setState(() {
      _hasError = false;
      _isLoading = true;
    });
    await _controller.reload();
  }

  Future<bool> _onWillPop() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
      return false;
    }
    bool isCancel = false;
    await PopUpItems.materialPopup(
        title: "Exit Payment",
        content: "Are you sure you want to exit the payment process?",
        cancelBtnPresses: () {
          isCancel = false;
        },
        okBtnPressed: () {
          isCancel = true;
        });
    return isCancel;
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: ColorConst.red,
            ),
            const SizedBox(height: 20),
            const Text(
              'Payment Loading Failed',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _errorMessage.isNotEmpty
                  ? _errorMessage
                  : 'Unable to load payment page. Please check your internet connection.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _refreshPage,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  label: const Text('Cancel'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onUrlChange(
      {required String uri,
      bool? flagError,
      required WebViewPaymentGatewayModel webViewPaymentGatewayModel}) {
    if (uri.contains(webViewPaymentGatewayModel.redirectLink)) {
      Navigator.of(CurrentContext().context)
          .pop({"PayMent_STATUS": "TXN_SUCCESS"});
    } else if (ValueHandler.isTextNotEmptyOrNull(
            webViewPaymentGatewayModel.failedRedirectLink) &&
        uri.contains(webViewPaymentGatewayModel.failedRedirectLink ?? "")) {
      Navigator.of(CurrentContext().context)
          .pop({"PayMent_STATUS": "TXN_FAILED"});
    } else if (flagError == true) {
      Navigator.of(CurrentContext().context)
          .pop({"PayMent_STATUS": "TXN_ERROR"});
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, val) async {
        if (didPop) return; // system back already handled
        bool shouldPop = await _onWillPop();
        if (context.mounted && shouldPop) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: CustomIconButton(
            onPressed: () async {
              bool shouldPop = await _onWillPop();
              if (context.mounted && shouldPop) {
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.arrow_back_sharp),
            color: ColorConst.primaryDark,
          ),
          title: CustomTextEnum(
            widget.webViewPaymentGatewayModel.title ?? "Payment Gateway",
            color: ColorConst.primaryDark,
            styleType: CustomTextStyleType.subHeading3,
          ),
        ),
        body: SafeArea(
          child: _hasError
              ? _buildErrorWidget()
              : Stack(
                  children: [
                    WebViewWidget(
                      key: Key(widget.webViewPaymentGatewayModel.transactionId),
                      controller: _controller,
                    ),
                    if (_isLoading)
                      Container(
                        color: Colors.white.withOpacity(0.8),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text(
                                'Loading Payment Gateway...',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
