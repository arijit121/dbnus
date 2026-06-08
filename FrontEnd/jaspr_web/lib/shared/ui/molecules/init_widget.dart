import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import '../../constants/theme.dart';

/// A premium initialization screen displayed when the application or major features are loading up.
class InitWidget extends StatelessComponent {
  final String? title;
  final String? subtitle;

  const InitWidget({
    this.title = 'Dbnus',
    this.subtitle = 'Initializing application...',
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return div(classes: 'init-container', [
      div(classes: 'init-logo-wrapper', [
        div(classes: 'init-logo', [
          span([Component.text('D')]),
        ]),
        div(classes: 'init-logo-ring', []),
      ]),
      h2(classes: 'init-title', [Component.text(title!)]),
      p(classes: 'init-subtitle', [Component.text(subtitle!)]),
      div(classes: 'init-progress-bar', [
        div(classes: 'init-progress-value', []),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
        css('.init-container').styles(
          display: .flex,
          flexDirection: .column,
          alignItems: .center,
          justifyContent: .center,
          padding: .all(40.px),
          gap: Gap.all(16.px),
          raw: {'min-height': '100vh', 'text-align': 'center'},
        ),
        css('.init-logo-wrapper').styles(
          raw: {
            'position': 'relative',
            'width': '80px',
            'height': '80px',
            'margin-bottom': '12px',
          },
        ),
        css('.init-logo').styles(
          width: 100.percent,
          height: 100.percent,
          radius: .all(.circular(24.px)),
          display: .flex,
          alignItems: .center,
          justifyContent: .center,
          color: Colors.white,
          fontWeight: .w800,
          fontSize: 36.px,
          raw: {
            'background': 'linear-gradient(135deg, #6366F1, #8B5CF6)',
            'box-shadow': '0 10px 25px rgba(99, 102, 241, 0.3)',
            'animation': 'pulse 2s infinite ease-in-out',
            'z-index': '2',
          },
        ),
        css('.init-logo-ring').styles(
          width: 100.percent,
          height: 100.percent,
          radius: .all(.circular(24.px)),
          raw: {
            'position': 'absolute',
            'inset': '0',
            'border': '2px solid #6366F1',
            'opacity': '0',
            'animation': 'ping 2s infinite cubic-bezier(0, 0, 0.2, 1)',
            'z-index': '1',
          },
        ),
        css('.init-title').styles(
          fontSize: 24.px,
          fontWeight: .w800,
          color: primaryDark,
          margin: .zero,
          raw: {'letter-spacing': '-0.02em'},
        ),
        css('.init-subtitle').styles(
          fontSize: 14.px,
          fontWeight: .w400,
          color: secondaryDark,
          margin: .zero,
        ),
        css('.init-progress-bar').styles(
          width: 140.px,
          height: 4.px,
          radius: .all(.circular(2.px)),
          backgroundColor: lightGrey,
          raw: {'overflow': 'hidden', 'margin-top': '8px'},
        ),
        css('.init-progress-value').styles(
          width: 100.percent,
          height: 100.percent,
          backgroundColor: baseHexColor,
          raw: {
            'animation': 'indeterminate 1.5s infinite linear',
            'transform-origin': '0% 50%',
          },
        ),
        css.keyframes('pulse', {
          '0%, 100%': Styles(raw: {'transform': 'scale(1)'}),
          '50%': Styles(raw: {'transform': 'scale(1.05)'}),
        }),
        css.keyframes('ping', {
          '0%': Styles(raw: {'transform': 'scale(1)', 'opacity': '0.8'}),
          '75%, 100%': Styles(raw: {'transform': 'scale(1.4)', 'opacity': '0'}),
        }),
        css.keyframes('indeterminate', {
          '0%': Styles(raw: {'transform': 'translateX(-100%) scaleX(0.2)'}),
          '50%': Styles(raw: {'transform': 'translateX(0%) scaleX(0.5)'}),
          '100%': Styles(raw: {'transform': 'translateX(100%) scaleX(0.2)'}),
        }),
      ];
}
