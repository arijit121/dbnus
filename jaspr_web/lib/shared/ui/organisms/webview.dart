import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class Webview extends StatelessComponent {
  final Uri? initialUri;
  final String? initialHtml;
  final double? width;
  final double? height;
  final String? className;

  const Webview({
    this.initialUri,
    this.initialHtml,
    this.width,
    this.height,
    this.className,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return iframe(
      classes: className,
      src: initialUri?.toString() ?? '',
      attributes: {
        if (initialHtml != null) 'srcdoc': initialHtml!,
      },
      styles: Styles(raw: {
        'width': width != null ? '${width}px' : '100%',
        'height': height != null ? '${height}px' : '100%',
        'border': 'none',
        'box-sizing': 'border-box',
      }),
      [],
    );
  }
}
