import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'package:dbnus/shared/ui/molecules/error/error_widget.dart';

class YoutubeVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final double? height;
  final double? width;

  const YoutubeVideoPlayer({
    super.key,
    required this.videoUrl,
    this.height,
    this.width,
  }) : assert(height != null || width != null,
            'Height or Width must be provided for YoutubeVideoPlayer');

  @override
  State<YoutubeVideoPlayer> createState() => _YoutubeVideoPlayerState();
}

class _YoutubeVideoPlayerState extends State<YoutubeVideoPlayer> {
  YoutubePlayerController? _controller;
  String? videoId;

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    videoId = YoutubePlayerController.convertUrlToId(widget.videoUrl);
    _controller = YoutubePlayerController(
        params: const YoutubePlayerParams(showFullscreenButton: true));

    await _controller?.cueVideoById(videoId: videoId!); // your YouTube video id

    setState(() {});
  }

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final aspectRatio = widget.height != null && widget.width != null
        ? widget.width! / widget.height!
        : 16 / 9;

    double width = widget.width ?? (widget.height ?? 0) * aspectRatio;
    double height = widget.height ?? (widget.width ?? 0) / aspectRatio;

    return _controller != null && videoId != null
        ? YoutubePlayer(
            controller: _controller!,
            aspectRatio: aspectRatio,
          )
        : CustomErrorWidget(width: width, height: height);
  }
}
