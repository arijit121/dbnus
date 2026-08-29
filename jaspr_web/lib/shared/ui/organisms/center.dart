import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class Center extends StatelessComponent {
  final Component child;
  final String? className;
  final Styles? style;

  const Center({
    required this.child,
    this.className,
    this.style,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'layout-center ${className ?? ''}'.trim(),
      styles: Styles.combine([
        Styles(raw: {
          'display': 'flex',
          'justify-content': 'center',
          'align-items': 'center',
          'width': '100%',
          'height': '100%',
        }),
        if (style != null) style!,
      ]),
      [child],
    );
  }
}
