import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class CustomImage extends StatelessComponent {
  final String src;
  final String? alt;
  final double? width;
  final double? height;
  final String? className;
  final bool rounded;

  const CustomImage({
    required this.src,
    this.alt,
    this.width,
    this.height,
    this.className,
    this.rounded = false,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return img(
      classes: 'custom-img ${rounded ? "img-rounded" : ""} ${className ?? ""}'.trim(),
      src: src,
      alt: alt ?? '',
      styles: Styles(raw: {
        if (width != null) 'width': '${width}px',
        if (height != null) 'height': '${height}px',
      }),
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.custom-img').styles(
      raw: {'object-fit': 'cover', 'max-width': '100%'},
    ),
    css('.img-rounded').styles(
      radius: .all(.circular(12.px)),
    ),
  ];
}
