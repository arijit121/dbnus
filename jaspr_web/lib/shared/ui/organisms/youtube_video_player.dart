import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import '../ui.dart';

class YoutubeVideoPlayer extends StatelessComponent {
  final String videoUrl;
  final double? height;
  final double? width;
  final String? className;

  const YoutubeVideoPlayer({
    required this.videoUrl,
    this.height = 315,
    this.width = 560,
    this.className,
    super.key,
  });

  String _extractVideoId(String url) {
    if (url.contains('youtu.be/')) {
      return url.split('youtu.be/').last.split('?').first;
    } else if (url.contains('v=')) {
      return url.split('v=').last.split('&').first;
    } else if (url.contains('embed/')) {
      return url.split('embed/').last.split('?').first;
    }
    return url;
  }

  @override
  Component build(BuildContext context) {
    final videoId = _extractVideoId(videoUrl);
    final embedUrl = 'https://www.youtube.com/embed/$videoId';

    return Container(
      className: className,
      width: width,
      height: height,
      style: Styles(raw: {
        'border-radius': '12px',
        'overflow': 'hidden',
        'box-shadow': '0 4px 16px rgba(0,0,0,0.1)',
      }),
      child: iframe(
        src: embedUrl,
        styles: Styles(raw: {
          'width': '100%',
          'height': '100%',
          'border': 'none',
        }),
        [],
      ),
    );
  }
}
