import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import '../../constants/theme.dart';

class StatCard extends StatelessComponent {
  final String title;
  final String value;
  final String? subtitle;
  final String? icon;
  final Color? accentColor;

  const StatCard({
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.accentColor,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return div(classes: 'stat-card', [
      div(classes: 'stat-card-header', [
        span(classes: 'stat-card-icon', styles: Styles(raw: {
          'background': 'linear-gradient(135deg, ${(accentColor ?? baseHexColor).value}20, ${(accentColor ?? baseHexColor).value}10)',
          'color': (accentColor ?? baseHexColor).value,
        }), [text(icon ?? '📊')]),
        p(classes: 'stat-card-title', [text(title)]),
      ]),
      h3(classes: 'stat-card-value', [text(value)]),
      if (subtitle != null)
        p(classes: 'stat-card-subtitle', [text(subtitle!)]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.stat-card', [
      css('&').styles(
        backgroundColor: Colors.white,
        radius: .all(.circular(16.px)),
        padding: .all(20.px),
        raw: {'box-shadow': '0 1px 3px rgba(0,0,0,0.04), 0 1px 2px rgba(0,0,0,0.06)', 'transition': 'transform 0.2s ease, box-shadow 0.2s ease'},
      ),
      css('&:hover').styles(
        raw: {'transform': 'translateY(-2px)', 'box-shadow': '0 4px 12px rgba(0,0,0,0.08)'},
      ),
      css('.stat-card-header').styles(
        display: .flex,
        alignItems: .center,
        gap: Gap.all(10.px),
        raw: {'margin-bottom': '12px'},
      ),
      css('.stat-card-icon').styles(
        display: .flex,
        alignItems: .center,
        justifyContent: .center,
        width: 40.px,
        height: 40.px,
        radius: .all(.circular(10.px)),
        fontSize: 18.px,
      ),
      css('.stat-card-title').styles(
        fontSize: 13.px,
        fontWeight: .w500,
        color: secondaryDark,
        margin: .zero,
      ),
      css('.stat-card-value').styles(
        fontSize: 28.px,
        fontWeight: .w700,
        color: primaryDark,
        margin: .zero,
        raw: {'margin-bottom': '4px'},
      ),
      css('.stat-card-subtitle').styles(
        fontSize: 12.px,
        color: green,
        margin: .zero,
        fontWeight: .w500,
      ),
    ]),
  ];
}
