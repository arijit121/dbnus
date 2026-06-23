import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

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
  ];
}
