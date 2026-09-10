import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class Flexible extends StatelessComponent {
  final int flex;
  final Component child;
  final String? className;
  final Styles? style;

  const Flexible({
    this.flex = 1,
    required this.child,
    this.className,
    this.style,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'layout-flexible ${className ?? ''}'.trim(),
      styles: Styles.combine([
        Styles(raw: {
          'flex': '$flex 1 auto',
        }),
        if (style != null) style!,
      ]),
      [child],
    );
  }
}
