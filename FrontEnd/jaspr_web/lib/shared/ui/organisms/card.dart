import 'package:jaspr/dom.dart' hide BorderRadius;
import 'package:jaspr/jaspr.dart';
import 'layout_types.dart';

export 'layout_types.dart';

class Card extends StatelessComponent {
  final Component child;
  final double elevation;
  final String? color;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final String? className;
  final Styles? style;

  const Card({
    required this.child,
    this.elevation = 1.0,
    this.color,
    this.margin,
    this.padding,
    this.borderRadius,
    this.className,
    this.style,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'layout-card ${className ?? ''}'.trim(),
      styles: Styles.combine([
        Styles(raw: {
          'display': 'block',
          if (color != null) 'background-color': color!,
          if (margin != null) 'margin': margin.toString(),
          if (padding != null) 'padding': padding.toString(),
          'border-radius': (borderRadius ?? const BorderRadius.all(4.0)).toString(),
          'box-shadow': _mapElevation(elevation),
          'box-sizing': 'border-box',
        }),
        if (style != null) style!,
      ]),
      [child],
    );
  }

  String _mapElevation(double elevation) {
    if (elevation <= 0) return 'none';
    final blur = elevation * 2;
    final spread = elevation * 0.5;
    return '0px ${elevation}px ${blur}px ${spread}px rgba(0, 0, 0, 0.1)';
  }
}
