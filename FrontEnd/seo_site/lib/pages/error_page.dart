import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class ErrorRouteWidget extends StatelessComponent {
  const ErrorRouteWidget({super.key});

  @override
  Component build(BuildContext context) {
    return section([
      h1([Component.text('404 - Page Not Found')]),
      p([Component.text('The requested page could not be found.')]),
      a(href: '/', [Component.text('Go to Home')])
    ]);
  }
}
