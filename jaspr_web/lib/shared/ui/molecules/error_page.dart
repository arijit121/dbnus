import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';
import '../../constants/theme.dart';

class ErrorPage extends StatelessComponent {
  const ErrorPage({super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'error-page', [
      div(classes: 'error-illustration', [text('404')]),
      h2([text('Page Not Found')]),
      p(classes: 'error-desc', [text('The page you\'re looking for doesn\'t exist or has been moved.')]),
      button(
        classes: 'error-home-btn',
        events: {'click': (e) => Router.of(context).push('/')},
        [text('← Back to Dashboard')],
      ),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.error-page').styles(
      display: .flex, flexDirection: .column, alignItems: .center,
      justifyContent: .center, gap: Gap.all(16.px), padding: .all(40.px),
      raw: {'min-height': '80vh', 'text-align': 'center', 'animation': 'fadeIn 0.4s ease'},
    ),
    css('.error-illustration').styles(
      fontSize: 80.px, fontWeight: .w800,
      raw: {'background': 'linear-gradient(135deg, #6366F1, #8B5CF6)', '-webkit-background-clip': 'text', '-webkit-text-fill-color': 'transparent'},
    ),
    css('.error-desc').styles(color: secondaryDark, fontSize: 14.px, raw: {'max-width': '400px'}),
    css('.error-home-btn').styles(
      padding: .symmetric(horizontal: 24.px, vertical: 12.px),
      radius: .all(.circular(12.px)), backgroundColor: baseHexColor,
      color: Colors.white, fontSize: 14.px, fontWeight: .w600,
      cursor: .pointer, border: .none,
      raw: {'transition': 'all 0.2s ease', 'margin-top': '8px'},
    ),
    css('.error-home-btn:hover').styles(raw: {'transform': 'translateY(-2px)', 'box-shadow': '0 4px 12px rgba(108,99,255,0.4)'}),
  ];
}
