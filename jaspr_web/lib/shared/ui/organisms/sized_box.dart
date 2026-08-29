import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class SizedBox extends StatelessComponent {
  final double? width;
  final double? height;
  final Component? child;
  final String? className;
  final Styles? style;

  const SizedBox({
    this.width,
    this.height,
    this.child,
    this.className,
    this.style,
    super.key,
  });

  const SizedBox.shrink({
    this.child,
    this.className,
    this.style,
    super.key,
  })  : width = 0.0,
        height = 0.0;

  const SizedBox.expand({
    this.child,
    this.className,
    this.style,
    super.key,
  })  : width = double.infinity,
        height = double.infinity;

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'layout-sizedbox ${className ?? ''}'.trim(),
      styles: Styles.combine([
        Styles(raw: {
          if (width != null) 'width': width == double.infinity ? '100%' : '${width}px',
          if (height != null) 'height': height == double.infinity ? '100%' : '${height}px',
          'box-sizing': 'border-box',
        }),
        if (style != null) style!,
      ]),
      child != null ? [child!] : [],
    );
  }
}
