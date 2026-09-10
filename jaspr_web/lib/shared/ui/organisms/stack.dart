import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'layout_types.dart';

export 'layout_types.dart';

class Stack extends StatelessComponent {
  final List<Component> children;
  final Alignment alignment;
  final String? className;
  final Styles? style;

  const Stack({
    required this.children,
    this.alignment = Alignment.topLeft,
    this.className,
    this.style,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'layout-stack ${className ?? ''}'.trim(),
      styles: Styles.combine([
        Styles(raw: {
          'position': 'relative',
          'width': '100%',
          'height': '100%',
        }),
        if (style != null) style!,
      ]),
      children,
    );
  }
}

class Positioned extends StatelessComponent {
  final double? top;
  final double? right;
  final double? bottom;
  final double? left;
  final double? width;
  final double? height;
  final Component child;
  final String? className;
  final Styles? style;

  const Positioned({
    this.top,
    this.right,
    this.bottom,
    this.left,
    this.width,
    this.height,
    required this.child,
    this.className,
    this.style,
    super.key,
  });

  const Positioned.fill({
    required this.child,
    this.className,
    this.style,
    super.key,
  })  : top = 0.0,
        right = 0.0,
        bottom = 0.0,
        left = 0.0,
        width = null,
        height = null;

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'layout-positioned ${className ?? ''}'.trim(),
      styles: Styles.combine([
        Styles(raw: {
          'position': 'absolute',
          if (top != null) 'top': '${top}px',
          if (right != null) 'right': '${right}px',
          if (bottom != null) 'bottom': '${bottom}px',
          if (left != null) 'left': '${left}px',
          if (width != null) 'width': '${width}px',
          if (height != null) 'height': '${height}px',
        }),
        if (style != null) style!,
      ]),
      [child],
    );
  }
}
