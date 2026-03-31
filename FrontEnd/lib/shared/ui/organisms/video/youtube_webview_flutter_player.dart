import 'package:dbnus/shared/extensions/logger_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import 'package:dbnus/shared/ui/molecules/error/error_widget.dart';

class YoutubeWebviewFlutterPlayer extends StatefulWidget {
  final String videoUrl;
  final double? height;
  final double? width;

  const YoutubeWebviewFlutterPlayer({
    super.key,
    required this.videoUrl,
    this.height,
    this.width,
  }) : assert(height != null || width != null,
            'Height or Width must be provided for YoutubeWebviewFlutterPlayer');

  @override
  State<YoutubeWebviewFlutterPlayer> createState() =>
      _YoutubeWebviewFlutterPlayerState();
}

class _YoutubeWebviewFlutterPlayerState
    extends State<YoutubeWebviewFlutterPlayer> {
  String? videoId;
  WebViewController? _controller;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    videoId = _convertUrlToId(widget.videoUrl);
    AppLog.i(videoId, tag: "Video Id");

    if (videoId != null) {
      late final PlatformWebViewControllerCreationParams params;

      if (WebViewPlatform.instance is WebKitWebViewPlatform) {
        params = WebKitWebViewControllerCreationParams(
          allowsInlineMediaPlayback: true,
          mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
        );
      } else {
        params = const PlatformWebViewControllerCreationParams();
      }

      final controller = WebViewController.fromPlatformCreationParams(params)
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.transparent)
        ..setUserAgent(
            "Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 Chrome/120.0.0.0 Safari/537.36")
        ..addJavaScriptChannel(
          'Webviewtube',
          onMessageReceived: (JavaScriptMessage message) {
            AppLog.i(message.message, tag: "Webviewtube");
          },
        );

      if (controller.platform is AndroidWebViewController) {
        (controller.platform as AndroidWebViewController)
            .setMediaPlaybackRequiresUserGesture(false);
      } else if (controller.platform is WebKitWebViewController) {
        (controller.platform as WebKitWebViewController)
            .setAllowsBackForwardNavigationGestures(false);
      }

      try {
        String htmlTemplate =
            await rootBundle.loadString('assets/store/youtube_player.html');

        String htmlContent = htmlTemplate
            .replaceAll('{{VIDEO_ID}}', videoId!)
            .replaceAll('{{ENABLE_CAPTION}}', '0')
            .replaceAll('{{CAPTION_LANGUAGE}}', 'en')
            .replaceAll('{{SHOW_CONTROLS}}', '1')
            .replaceAll('{{ENABLE_FULLSCREEN}}', '0')
            .replaceAll('{{INTERFACE_LANGUAGE}}', 'en')
            .replaceAll('{{LOOP}}', '0')
            .replaceAll('{{PLAYLIST_PARAM}}', '')
            .replaceAll('{{ORIGIN_PARAM}}', "'origin': 'https://www.youtube-nocookie.com',")
            .replaceAll('{{START_AT}}', '0')
            .replaceAll('{{END_AT}}', '0')
            .replaceAll('{{UPDATE_INTERVAL}}', '1000');

        await controller.loadHtmlString(htmlContent,
            baseUrl: 'https://www.youtube-nocookie.com/');

        if (mounted) {
          setState(() {
            _controller = controller;
          });
        }
      } catch (e) {
        AppLog.e('Error loading YouTube HTML template: $e');
      }
    }
  }

  String? _convertUrlToId(String url, {bool trimWhitespaces = true}) {
    if (!url.contains("http") && (url.length == 11)) return url;
    if (trimWhitespaces) url = url.trim();

    for (var exp in [
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube\.com\/v\/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?.*v=([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube\.com\/shorts\/([_\-a-zA-Z0-9]{11}).*$"),
    ]) {
      Match? match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 1) return match.group(1);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final aspectRatio = widget.height != null && widget.width != null
        ? widget.width! / widget.height!
        : 16 / 9;

    double width = widget.width ?? (widget.height ?? 0) * aspectRatio;
    double height = widget.height ?? (widget.width ?? 0) / aspectRatio;

    if (videoId == null) {
      return CustomErrorWidget(width: width, height: height);
    }

    if (_controller == null) {
      return SizedBox(
        width: width,
        height: height,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: WebViewWidget(controller: _controller!),
    );
  }
}
