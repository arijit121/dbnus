import 'package:dbnus/shared/extensions/logger_extension.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    videoId = _convertUrlToId(widget.videoUrl);
    AppLog.i(videoId, tag: "Video Id");

    if (videoId != null) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.transparent)
        ..loadRequest(Uri.parse(
            "https://www.youtube.com/embed/$videoId?playsinline=1&rel=0&fs=0&modestbranding=1&iv_load_policy=3&origin=https://www.youtube.com"));
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

    return SizedBox(
      width: width,
      height: height,
      child: WebViewWidget(controller: _controller),
    );
  }
}
