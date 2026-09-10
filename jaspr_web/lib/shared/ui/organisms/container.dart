import 'package:jaspr/dom.dart' hide BorderRadius;
import 'package:jaspr/jaspr.dart';
import 'layout_types.dart';

export 'layout_types.dart';

class Container extends StatelessComponent {
  final Component? child;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final String? color;
  final BoxDecoration? decoration;
  final Alignment? alignment;
  final String? className;
  final Styles? style;
  final Map<String, EventCallback>? events;

  const Container({
    this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.color,
    this.decoration,
    this.alignment,
    this.className,
    this.style,
    this.events,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    final Map<String, String> rawStyles = {
      'box-sizing': 'border-box',
    };

    if (width != null) rawStyles['width'] = '${width}px';
    if (height != null) rawStyles['height'] = '${height}px';
    if (padding != null) rawStyles['padding'] = padding.toString();
    if (margin != null) rawStyles['margin'] = margin.toString();

    if (decoration != null) {
      if (decoration!.color != null) {
        rawStyles['background-color'] = decoration!.color!;
      }
      if (decoration!.borderRadius != null) {
        rawStyles['border-radius'] = decoration!.borderRadius!.toString();
      }
      if (decoration!.border != null) {
        final border = decoration!.border!;
        if (border.top != null) {
          rawStyles['border-top'] = '${border.top!.width}px ${border.top!.style} ${border.top!.color}';
        }
        if (border.right != null) {
          rawStyles['border-right'] = '${border.right!.width}px ${border.right!.style} ${border.right!.color}';
        }
        if (border.bottom != null) {
          rawStyles['border-bottom'] = '${border.bottom!.width}px ${border.bottom!.style} ${border.bottom!.color}';
        }
        if (border.left != null) {
          rawStyles['border-left'] = '${border.left!.width}px ${border.left!.style} ${border.left!.color}';
        }
      }
      if (decoration!.boxShadow != null) {
        rawStyles['box-shadow'] = decoration!.boxShadow!.map((shadow) => shadow.toString()).join(', ');
      }
    } else if (color != null) {
      rawStyles['background-color'] = color!;
    }

    if (alignment != null) {
      rawStyles['display'] = 'flex';
      final (justify, align) = _mapAlignment(alignment!);
      rawStyles['justify-content'] = justify;
      rawStyles['align-items'] = align;
    }

    return div(
      classes: 'layout-container ${className ?? ''}'.trim(),
      styles: Styles.combine([
        Styles(raw: rawStyles),
        if (style != null) style!,
      ]),
      events: events,
      child != null ? [child!] : [],
    );
  }

  (String, String) _mapAlignment(Alignment alignment) {
    return switch (alignment) {
      Alignment.topLeft => ('flex-start', 'flex-start'),
      Alignment.topCenter => ('center', 'flex-start'),
      Alignment.topRight => ('flex-end', 'flex-start'),
      Alignment.centerLeft => ('flex-start', 'center'),
      Alignment.center => ('center', 'center'),
      Alignment.centerRight => ('flex-end', 'center'),
      Alignment.bottomLeft => ('flex-start', 'flex-end'),
      Alignment.bottomCenter => ('center', 'flex-end'),
      Alignment.bottomRight => ('flex-end', 'flex-end'),
    };
  }
}
