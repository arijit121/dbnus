import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class ShimmerLoading extends StatelessComponent {
  final Component child;
  final double? width;
  final double? height;
  final double? borderRadius;
  final String? className;

  const ShimmerLoading({
    required this.child,
    this.width,
    this.height,
    this.borderRadius,
    this.className,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'shimmer-effect ${className ?? ""}'.trim(),
      styles: Styles(raw: {
        if (width != null) 'width': '${width}px',
        if (height != null) 'height': '${height}px',
        if (borderRadius != null) 'border-radius': '${borderRadius}px',
      }),
      [child],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.shimmer-effect', [
      css('&').styles(
        raw: {
          'background': 'linear-gradient(90deg, #EBEBF4 0%, #F4F4F4 50%, #EBEBF4 100%)',
          'background-size': '200% 100%',
          'animation': 'shimmerAnimation 1.5s infinite linear',
        },
      ),
    ]),
    css.keyframes('shimmerAnimation', {
      '0%': Styles(raw: {'background-position': '200% 0'}),
      '100%': Styles(raw: {'background-position': '-200% 0'}),
    }),
  ];
}
