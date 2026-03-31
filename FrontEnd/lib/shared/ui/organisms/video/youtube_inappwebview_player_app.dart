
/// For App
import 'dart:collection';
import 'package:dbnus/shared/extensions/logger_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:dbnus/shared/ui/molecules/error/error_widget.dart';

class YoutubeInAppWebviewPlayer extends StatefulWidget {
  final String videoUrl;
  final double? height;
  final double? width;

  const YoutubeInAppWebviewPlayer({
    super.key,
    required this.videoUrl,
    this.height,
    this.width,
  }) : assert(height != null || width != null,
            'Height or Width must be provided for YoutubeWebviewPlayer');

  @override
  State<YoutubeInAppWebviewPlayer> createState() =>
      _YoutubeInAppWebviewPlayerState();
}

class _YoutubeInAppWebviewPlayerState extends State<YoutubeInAppWebviewPlayer> {
  String? videoId;
  String? _htmlContent;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    videoId = _convertUrlToId(widget.videoUrl);
    AppLog.i(videoId, tag: "Video Id");

    if (videoId != null) {
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
            .replaceAll(
                '{{ORIGIN_PARAM}}', "'origin': 'https://www.youtube.com',")
            .replaceAll('{{START_AT}}', '0')
            .replaceAll('{{END_AT}}', '0')
            .replaceAll('{{UPDATE_INTERVAL}}', '1000')
            .replaceAll('Webviewtube.postMessage(',
                'window.flutter_inappwebview.callHandler("Webviewtube", ');

        if (mounted) {
          setState(() {
            _htmlContent = htmlContent;
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

    if (_htmlContent == null) {
      return SizedBox(
        width: width,
        height: height,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: InAppWebView(
        initialData: InAppWebViewInitialData(
          data: _htmlContent!,
          baseUrl: WebUri("https://www.youtube-nocookie.com/"),
        ),
        initialSettings: InAppWebViewSettings(
          userAgent:
              "Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 Chrome/120.0.0.0 Safari/537.36",
          mediaPlaybackRequiresUserGesture: false,
          allowsInlineMediaPlayback: true,
          iframeAllowFullscreen: false,
          iframeAllow:
              "accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture",
          useHybridComposition: true,
        ),
        onWebViewCreated: (controller) {
          controller.addJavaScriptHandler(
            handlerName: 'Webviewtube',
            callback: (args) {
              AppLog.i(args.toString(), tag: "Webviewtube");
            },
          );
        },
      ),
    );
  }
}
