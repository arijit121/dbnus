import 'dart:js_interop';

import 'package:web/web.dart' as web;
import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';

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
  late final web.HTMLIFrameElement _iframeElement;
  late final String _viewId;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _viewId = 'webview-${DateTime.now().millisecondsSinceEpoch}';
    _initWebView();
  }

  void _initWebView() {
    // -----------------------------------------------------------------
    // 1. Create IFrame element
    // -----------------------------------------------------------------
    _iframeElement = web.HTMLIFrameElement()
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%'
      ..allow = 'camera; microphone; payment; autoplay; fullscreen'
      ..allowFullscreen = true;

    // -----------------------------------------------------------------
    // 2. Setup navigation/load listeners
    // -----------------------------------------------------------------
    _iframeElement.onLoad.listen((event) {
      AppLog.i(_iframeElement.src, tag: "PAGE FINISHED");
      setState(() => _isLoaded = true);
    });

    _iframeElement.onError.listen((event) {
      AppLog.e(event.toString(), tag: "WEBVIEW ERROR");
    });

    // -----------------------------------------------------------------
    // 3. Monitor navigation changes (if callback provided)
    // -----------------------------------------------------------------
    if (widget.onUriChanged != null) {
      // Note: Cross-origin restrictions may limit this functionality
      // You may need to implement postMessage communication for full control

      _iframeElement.onchange = (JSAny? event) {
        final url = _iframeElement.src;
        widget.onUriChanged!(url);
      }.toJS;
    }

    // -----------------------------------------------------------------
    // 4. Load content
    // -----------------------------------------------------------------
    if (widget.initialUri != null) {
      debugPrint('PAGE STARTED: ${widget.initialUri}');
      _iframeElement.src = widget.initialUri.toString();
    } else if (widget.initialHtml?.isNotEmpty == true) {
      debugPrint('PAGE STARTED: [HTML content]');
      // For HTML content, use srcdoc
      _iframeElement.src = widget.initialHtml!;
    }

    // -----------------------------------------------------------------
    // 5. Register the view factory
    // -----------------------------------------------------------------
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      _viewId,
      (int viewId) => _iframeElement,
    );
  }

  @override
  void dispose() {
    // Cleanup: remove the iframe from DOM if needed
    _iframeElement.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(
      viewType: _viewId,
    );
  }
}
