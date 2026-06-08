import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import 'shared/constants/theme.dart';
import 'navigation/router_manager.dart';

/// Root application component with routing.
/// Mirrors the Flutter app's `MyWebApp` + `RouterManager`.
class App extends StatelessComponent {
  const App({super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'main', [
      Router(
        routes: RouterManager.instance.routes,
      ),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.main', [
      css('&').styles(
        display: .flex,
        height: 100.vh,
        flexDirection: .column,
      ),
    ]),
    css('.game-standalone').styles(
      display: .flex,
      flexDirection: .column,
      backgroundColor: scaffoldBg,
      raw: {'min-height': '100vh'},
    ),
    css('.game-back-btn').styles(
      padding: .symmetric(horizontal: 16.px, vertical: 10.px),
      margin: .all(16.px),
      border: .none,
      radius: .all(.circular(10.px)),
      cursor: .pointer,
      color: primaryDark,
      fontSize: 14.px,
      fontWeight: .w600,
      backgroundColor: Colors.white,
      raw: {
        'box-shadow': '0 2px 8px rgba(0,0,0,0.06)',
        'transition': 'all 0.2s ease',
        'align-self': 'flex-start',
      },
    ),
    css('.game-back-btn:hover').styles(
      raw: {'transform': 'translateX(-4px)', 'box-shadow': '0 4px 12px rgba(0,0,0,0.1)'},
    ),
  ];
}
