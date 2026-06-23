import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class Spacer extends StatelessComponent {
  final int flex;
  final String? className;
  final Styles? style;

  const Spacer({
    this.flex = 1,
    this.className,
    this.style,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'layout-spacer ${className ?? ''}'.trim(),
      styles: Styles.combine([
        Styles(raw: {
          'flex': '$flex 1 0%',
        }),
        if (style != null) style!,
      ]),
      [],
    );
  }
}
