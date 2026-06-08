import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class Expanded extends StatelessComponent {
  final int flex;
  final Component child;
  final String? className;
  final Styles? style;

  const Expanded({
    this.flex = 1,
    required this.child,
    this.className,
    this.style,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'layout-expanded ${className ?? ''}'.trim(),
      styles: Styles.combine([
        Styles(raw: {
          'flex': '$flex 1 0%',
        }),
        if (style != null) style!,
      ]),
      [child],
    );
  }
}
