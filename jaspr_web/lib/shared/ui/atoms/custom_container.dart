import 'package:jaspr/dom.dart' hide BorderRadius, BoxShadow;
import 'package:jaspr/jaspr.dart';
import '../organisms/layout_types.dart';

class CustomContainer extends StatelessComponent {
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;
  final Color? color;
  final Component? child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? borderColor;
  final List<BoxShadow>? boxShadow;
  final String? className;
  final Styles? style;
  final void Function()? onTap;

  const CustomContainer({
    this.height,
    this.width,
    this.borderRadius,
    this.color,
    this.child,
    this.padding,
    this.margin,
    this.borderColor,
    this.boxShadow,
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
          if (padding != null) 'padding': padding!.toString(),
          if (margin != null) 'margin': margin!.toString(),
          if (color != null) 'background-color': color!.value,
          if (borderRadius != null) 'border-radius': borderRadius!.toString(),
          if (borderColor != null) 'border': '1px solid ${borderColor!.value}',
          if (boxShadow != null && boxShadow!.isNotEmpty)
            'box-shadow': boxShadow!.map((shadow) => shadow.toString()).join(', '),
          if (onTap != null) 'cursor': 'pointer',
          'box-sizing': 'border-box',
        }),
        if (style != null) style!,
      ]),
      events: onTap != null ? {'click': (e) => onTap!()} : {},
      [if (child != null) child!],
    );
  }
}
