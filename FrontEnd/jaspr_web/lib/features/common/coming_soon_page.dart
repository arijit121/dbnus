import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import '../../shared/constants/theme.dart';

class ComingSoonPage extends StatelessComponent {
  final String title;
  final String icon;
  const ComingSoonPage({this.title = 'Coming Soon', this.icon = '🚧', super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'cs-page', [
      div(classes: 'cs-icon', [text(icon)]),
      h2([text(title)]),
      p(classes: 'cs-desc', [text('This feature is under development. Check back soon!')]),
      div(classes: 'cs-dots', [
        span(classes: 'cs-dot', []),
        span(classes: 'cs-dot', []),
        span(classes: 'cs-dot', []),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.cs-page').styles(
      display: .flex, flexDirection: .column, alignItems: .center,
      justifyContent: .center, gap: Gap.all(16.px), padding: .all(40.px),
      raw: {'min-height': '400px', 'text-align': 'center', 'animation': 'fadeIn 0.4s ease'},
    ),
    css('.cs-icon').styles(fontSize: 64.px, raw: {'animation': 'bounce 2s infinite'}),
    css('.cs-desc').styles(color: secondaryDark, fontSize: 14.px, raw: {'max-width': '400px'}),
    css('.cs-dots').styles(display: .flex, gap: Gap.all(8.px), raw: {'margin-top': '12px'}),
    css('.cs-dot').styles(
      width: 10.px, height: 10.px,
      radius: .all(.circular(5.px)),
      backgroundColor: baseHexColor,
      raw: {'animation': 'pulse 1.5s infinite', 'opacity': '0.4'},
    ),
    css('.cs-dot:nth-child(2)').styles(raw: {'animation-delay': '0.3s'}),
    css('.cs-dot:nth-child(3)').styles(raw: {'animation-delay': '0.6s'}),
    css.keyframes('bounce', {
      '0%, 100%': Styles(raw: {'transform': 'translateY(0)'}),
      '50%': Styles(raw: {'transform': 'translateY(-10px)'}),
    }),
    css.keyframes('pulse', {
      '0%, 100%': Styles(raw: {'opacity': '0.4'}),
      '50%': Styles(raw: {'opacity': '1'}),
    }),
  ];
}
