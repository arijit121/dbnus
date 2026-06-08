import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';
import '../../constants/theme.dart';

class GameCard extends StatelessComponent {
  final String title;
  final String icon;
  final String route;
  final Color gradientStart;
  final Color gradientEnd;

  const GameCard({
    required this.title,
    required this.icon,
    required this.route,
    this.gradientStart = sidebarSelected,
    this.gradientEnd = violate,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return Link(
      to: route,
      child: div(classes: 'game-card', styles: Styles(raw: {
        'background': 'linear-gradient(135deg, ${gradientStart.value}, ${gradientEnd.value})',
      }), [
        div(classes: 'game-card-icon', [text(icon)]),
        p(classes: 'game-card-title', [text(title)]),
      ]),
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.game-card', [
      css('&').styles(
        radius: .all(.circular(16.px)),
        padding: .all(24.px),
        color: Colors.white,
        cursor: .pointer,
        raw: {
          'transition': 'transform 0.2s ease, box-shadow 0.2s ease',
          'text-align': 'center',
          'aspect-ratio': '1',
        },
        display: .flex,
        flexDirection: .column,
        alignItems: .center,
        justifyContent: .center,
        gap: Gap.all(12.px),
      ),
      css('&:hover').styles(
        raw: {'transform': 'translateY(-4px) scale(1.02)', 'box-shadow': '0 8px 25px rgba(99, 102, 241, 0.4)'},
      ),
      css('.game-card-icon').styles(fontSize: 40.px),
      css('.game-card-title').styles(fontSize: 14.px, fontWeight: .w600, margin: .zero),
    ]),
  ];
}
