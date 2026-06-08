import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import '../../constants/theme.dart';

class EmptyState extends StatelessComponent {
  final String icon;
  final String title;
  final String? subtitle;

  const EmptyState({this.icon = '📭', required this.title, this.subtitle, super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'empty-state', [
      div(classes: 'empty-icon', [text(icon)]),
      h4([text(title)]),
      if (subtitle != null)
        p(classes: 'empty-subtitle', [text(subtitle!)]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.empty-state').styles(
      display: .flex,
      flexDirection: .column,
      alignItems: .center,
      justifyContent: .center,
      padding: .all(40.px),
      gap: Gap.all(8.px),
      raw: {'text-align': 'center', 'min-height': '250px'},
    ),
    css('.empty-icon').styles(fontSize: 48.px, raw: {'margin-bottom': '8px'}),
    css('.empty-subtitle').styles(color: grey, fontSize: 13.px, margin: .zero),
  ];
}
