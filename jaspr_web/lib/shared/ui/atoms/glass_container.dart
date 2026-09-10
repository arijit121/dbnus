import 'package:jaspr/dom.dart' hide BorderRadius;
import 'package:jaspr/jaspr.dart';
import '../../constants/color_const.dart';
import '../organisms/layout_types.dart';

class GlassContainer extends StatelessComponent {
  final Component child;
  final double blur;
  final double borderRadius;
  final Color? color;
  final EdgeInsets padding;
  final double? width;
  final double? height;
  final String? className;
  final Styles? style;
  final void Function()? onTap;

  const GlassContainer({
    required this.child,
    this.blur = 12.0,
    this.borderRadius = 16.0,
    this.color,
    this.padding = const EdgeInsets.all(16),
    this.width,
    this.height,
    this.className,
    this.style,
    this.onTap,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes: className,
      styles: Styles.combine([
        Styles(raw: {
          if (width != null) 'width': '${width}px',
          if (height != null) 'height': '${height}px',
          'padding': padding.toString(),
          'background-color': color?.value ?? ColorConst.glassBackground.value,
          'backdrop-filter': 'blur(${blur}px)',
          '-webkit-backdrop-filter': 'blur(${blur}px)',
          'border': '1.5px solid ${ColorConst.glassBorder.value}',
          'border-radius': '${borderRadius}px',
          'box-sizing': 'border-box',
          if (onTap != null) 'cursor': 'pointer',
        }),
        if (style != null) style!,
      ]),
      events: onTap != null ? {'click': (e) => onTap!()} : {},
      [child],
    );
  }
}
