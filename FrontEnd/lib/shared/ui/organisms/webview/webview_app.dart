import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../../extensions/logger_extension.dart';

class Webview extends StatefulWidget {
  const Webview({
    super.key,
    this.initialUri,
    this.initialHtml,
    this.onUriChanged,
    this.onConsole,
  });

  final Uri? initialUri;
  final String? initialHtml;
  final bool Function(String)? onUriChanged;
  final void Function(String message, String level)? onConsole;

  @override
  State<Webview> createState() => _WebviewState();
}

class _WebviewState extends State<Webview> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  Future<void> _initWebView() async {
    // -----------------------------------------------------------------
    // 1. Platform-specific creation params
    // -----------------------------------------------------------------
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      // iOS – allow inline media (camera preview) without user gesture
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setOnConsoleMessage((consoleMessage) {
        if (widget.onConsole != null) {
          widget.onConsole!(consoleMessage.message, consoleMessage.level.name);
        }
      })
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            AppLog.i(url, tag: "PAGE STARTED");
          },
          onPageFinished: (url) {
            AppLog.i(url, tag: "PAGE FINISHED");
          },
          onWebResourceError: (error) {
            AppLog.e(error.toString(), tag: "WEBVIEW ERROR");
          },

          // Optional: block unsafe navigation
          onNavigationRequest: (request) {
            if (widget.onUriChanged != null) {
              bool value = widget.onUriChanged!(request.url);

              return value
                  ? NavigationDecision.navigate
                  : NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );

    // -----------------------------------------------------------------
    // 2. Android-specific tweaks
    // -----------------------------------------------------------------
    if (_controller.platform is AndroidWebViewController) {
      final androidCtrl = _controller.platform as AndroidWebViewController;

      // Auto-play media (camera) without tap
      await androidCtrl.setMediaPlaybackRequiresUserGesture(false);

      // Enable Chrome DevTools debugging
      await AndroidWebViewController.enableDebugging(false);

      // Enable Payment Enabled
      await androidCtrl.setPaymentRequestEnabled(true);

      // -----------------------------------------------------------------
      // 2a. Permission request from the WebView (Android 11+)
      // -----------------------------------------------------------------
      androidCtrl.setOnPlatformPermissionRequest((request) async {
        final resources = request.types;
        final granted = <String>[];
        for (final res in resources) {
          if (res == WebViewPermissionResourceType.camera) {
            if (await Permission.camera.request().isGranted) {
              granted.add(res.name);
            }
          } else if (res == WebViewPermissionResourceType.microphone) {
            if (await Permission.microphone.request().isGranted) {
              granted.add(res.name);
            }
          }
        }
        request.grant();
      });

      /* // -----------------------------------------------------------------
      // 2b. File chooser → open camera / gallery
      // -----------------------------------------------------------------
      androidCtrl.setOnShowFileSelector((params) async {
        // Use the built-in file picker (camera + gallery)
        final result = await AndroidWebViewController.defaultFileChooser(
          controller,
          params,
        );
        return result;
      });*/
    }

    // -----------------------------------------------------------------
    // 3. Load content
    // -----------------------------------------------------------------
    if (widget.initialUri != null) {
      await _controller.loadRequest(widget.initialUri!);
    } else if (widget.initialHtml?.isNotEmpty == true) {
      await _controller.loadHtmlString(widget.initialHtml!);
    }

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}
