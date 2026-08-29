import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import '../../constants/theme.dart';

class CustomDivider extends StatelessComponent {
  final bool vertical;
  const CustomDivider({this.vertical = false, super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: vertical ? 'divider-v' : 'divider-h', []);
  }

  @css
  static List<StyleRule> get styles => [
    css('.divider-h').styles(width: 100.percent, height: 1.px, backgroundColor: lineGrey),
    css('.divider-v').styles(width: 1.px, raw: {'align-self': 'stretch'}, backgroundColor: lineGrey),
  ];
}
