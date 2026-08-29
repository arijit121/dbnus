import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'layout_types.dart';

export 'layout_types.dart';

class Padding extends StatelessComponent {
  final EdgeInsets padding;
  final Component child;
  final String? className;
  final Styles? style;

  const Padding({
    required this.padding,
    required this.child,
    this.className,
    this.style,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'layout-padding ${className ?? ''}'.trim(),
      styles: Styles.combine([
        Styles(raw: {
          'padding': padding.toString(),
          'box-sizing': 'border-box',
        }),
        if (style != null) style!,
      ]),
      [child],
    );
  }
}
