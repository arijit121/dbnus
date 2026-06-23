import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import '../../constants/theme.dart';

enum TextVariant { h1, h2, h3, h4, body, bodySmall, caption, label }

class CustomText extends StatelessComponent {
  final String content;
  final TextVariant variant;
  final Color? color;
  final FontWeight? fontWeight;
  final String? className;

  const CustomText(
    this.content, {
    this.variant = TextVariant.body,
    this.color,
    this.fontWeight,
    this.className,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    final cls = 'text-${variant.name} ${className ?? ''}'.trim();
    switch (variant) {
      case TextVariant.h1:
        return h1(classes: cls, styles: _overrideStyles(), [text(content)]);
      case TextVariant.h2:
        return h2(classes: cls, styles: _overrideStyles(), [text(content)]);
      case TextVariant.h3:
        return h3(classes: cls, styles: _overrideStyles(), [text(content)]);
      case TextVariant.h4:
        return h4(classes: cls, styles: _overrideStyles(), [text(content)]);
      case TextVariant.body:
      case TextVariant.bodySmall:
      case TextVariant.caption:
      case TextVariant.label:
        return p(classes: cls, styles: _overrideStyles(), [text(content)]);
    }
  }

  Styles? _overrideStyles() {
    if (color == null && fontWeight == null) return null;
    return Styles(raw: {
      if (color != null) 'color': color.toString(),
      if (fontWeight != null) 'font-weight': _weightValue(fontWeight!),
    });
  }

  String _weightValue(FontWeight w) {
    return switch (w) {
      FontWeight.w300 => '300',
      FontWeight.w400 => '400',
      FontWeight.w500 => '500',
      FontWeight.w600 => '600',
      FontWeight.w700 => '700',
      FontWeight.w800 => '800',
      _ => '400',
    };
  }

  @css
  static List<StyleRule> get styles => [
    css('.text-h1').styles(fontSize: 2.rem, fontWeight: .w800, raw: {'line-height': '1.2'}),
    css('.text-h2').styles(fontSize: 1.5.rem, fontWeight: .w700, raw: {'line-height': '1.3'}),
    css('.text-h3').styles(fontSize: 1.25.rem, fontWeight: .w600, raw: {'line-height': '1.4'}),
    css('.text-h4').styles(fontSize: 1.1.rem, fontWeight: .w600, raw: {'line-height': '1.4'}),
    css('.text-body').styles(fontSize: 14.px, fontWeight: .w400, margin: .zero, raw: {'line-height': '1.5'}),
    css('.text-bodySmall').styles(fontSize: 13.px, fontWeight: .w400, margin: .zero, color: secondaryDark),
    css('.text-caption').styles(fontSize: 12.px, fontWeight: .w400, margin: .zero, color: grey),
    css('.text-label').styles(fontSize: 11.px, fontWeight: .w600, margin: .zero, raw: {'text-transform': 'uppercase', 'letter-spacing': '0.05em'}, color: grey),
  ];
}
