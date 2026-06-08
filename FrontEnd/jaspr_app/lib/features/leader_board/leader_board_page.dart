import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import '../../shared/constants/theme.dart';

class LeaderBoardPage extends StatefulComponent {
  const LeaderBoardPage({super.key});

  @override
  State<LeaderBoardPage> createState() => _LeaderBoardPageState();

  @css
  static List<StyleRule> get styles => _LeaderBoardPageState.styles;
}

class _LeaderBoardPageState extends State<LeaderBoardPage> {
  List<Map<String, dynamic>> _players = [
    {'name': 'Alex Johnson', 'score': 9850, 'rank': 1, 'icon': '🥇', 'trend': '+12'},
    {'name': 'Maria Garcia', 'score': 9420, 'rank': 2, 'icon': '🥈', 'trend': '+8'},
    {'name': 'James Wilson', 'score': 8990, 'rank': 3, 'icon': '🥉', 'trend': '+5'},
    {'name': 'Sarah Chen', 'score': 8750, 'rank': 4, 'icon': '4', 'trend': '+3'},
    {'name': 'David Kim', 'score': 8340, 'rank': 5, 'icon': '5', 'trend': '-2'},
    {'name': 'Emily Brown', 'score': 7980, 'rank': 6, 'icon': '6', 'trend': '+1'},
    {'name': 'Michael Lee', 'score': 7650, 'rank': 7, 'icon': '7', 'trend': '+4'},
    {'name': 'Lisa Wang', 'score': 7320, 'rank': 8, 'icon': '8', 'trend': '-1'},
    {'name': 'Robert Taylor', 'score': 6990, 'rank': 9, 'icon': '9', 'trend': '+2'},
    {'name': 'Amy Martinez', 'score': 6670, 'rank': 10, 'icon': '10', 'trend': '+6'},
  ];

  @override
  Component build(BuildContext context) {
    return div(classes: 'leaderboard', [
      // Header
      div(classes: 'lb-header', [
        h2([text('🏆 Leader Board')]),
        p(classes: 'lb-subtitle', [text('Top performers this season')]),
      ]),

      // Top 3 podium
      div(classes: 'podium', [
        _podiumCard(_players[1], 'silver'),
        _podiumCard(_players[0], 'gold'),
        _podiumCard(_players[2], 'bronze'),
      ]),

      // Full ranking list
      div(classes: 'ranking-card', [
        div(classes: 'ranking-header', [
          span(classes: 'rh-rank', [text('#')]),
          span(classes: 'rh-name', [text('Player')]),
          span(classes: 'rh-score', [text('Score')]),
          span(classes: 'rh-trend', [text('Trend')]),
        ]),
        for (var player in _players)
          _rankRow(player),
      ]),
    ]);
  }

  Component _podiumCard(Map<String, dynamic> player, String tier) {
    return div(classes: 'podium-card podium-$tier', [
      div(classes: 'podium-medal', [text(player['icon'] as String)]),
      p(classes: 'podium-name', [text(player['name'] as String)]),
      p(classes: 'podium-score', [text('${player['score']} pts')]),
    ]);
  }

  Component _rankRow(Map<String, dynamic> player) {
    final rank = player['rank'] as int;
    final isTop3 = rank <= 3;
    return div(classes: 'rank-row ${isTop3 ? "rank-top" : ""}', [
      span(classes: 'rank-num', [text('${player['rank']}')]),
      div(classes: 'rank-avatar', [
        text(((player['name'] as String)[0])),
      ]),
      span(classes: 'rank-name', [text(player['name'] as String)]),
      span(classes: 'rank-score', [text('${player['score']}')]),
      span(
        classes: 'rank-trend ${(player['trend'] as String).startsWith('+') ? "trend-up" : "trend-down"}',
        [text(player['trend'] as String)],
      ),
    ]);
  }

  static List<StyleRule> get styles => [
        css('.leaderboard').styles(
          display: .flex,
          flexDirection: .column,
          gap: Gap.all(24.px),
          raw: {'animation': 'fadeIn 0.4s ease'},
        ),
        css('.lb-header').styles(raw: {'text-align': 'center'}),
        css('.lb-subtitle').styles(color: secondaryDark, fontSize: 14.px, margin: .zero, raw: {'margin-top': '4px'}),
        // Podium
        css('.podium').styles(
          display: .flex,
          justifyContent: .center,
          alignItems: .end,
          gap: Gap.all(16.px),
          padding: .symmetric(vertical: 20.px),
        ),
        css('.podium-card', [
          css('&').styles(
            display: .flex,
            flexDirection: .column,
            alignItems: .center,
            padding: .all(20.px),
            radius: .all(.circular(16.px)),
            backgroundColor: Colors.white,
            width: 160.px,
            raw: {
              'box-shadow': '0 4px 16px rgba(0,0,0,0.06)',
              'transition': 'transform 0.2s ease',
            },
          ),
          css('&:hover').styles(raw: {'transform': 'translateY(-4px)'}),
          css('&.podium-gold').styles(raw: {
            'background': 'linear-gradient(135deg, #FEF3C7, #FDE68A)',
            'border': '2px solid #F59E0B',
            'order': '0',
            'padding-top': '28px',
            'padding-bottom': '28px',
          }),
          css('&.podium-silver').styles(raw: {
            'background': 'linear-gradient(135deg, #F1F5F9, #E2E8F0)',
            'border': '2px solid #94A3B8',
            'order': '-1',
          }),
          css('&.podium-bronze').styles(raw: {
            'background': 'linear-gradient(135deg, #FED7AA, #FDBA74)',
            'border': '2px solid #EA580C',
            'order': '1',
          }),
          css('.podium-medal').styles(fontSize: 36.px, raw: {'margin-bottom': '8px'}),
          css('.podium-name').styles(fontSize: 14.px, fontWeight: .w600, margin: .zero, color: primaryDark),
          css('.podium-score').styles(fontSize: 13.px, color: secondaryDark, margin: .zero, raw: {'margin-top': '4px'}),
        ]),
        // Ranking table
        css('.ranking-card').styles(
          backgroundColor: Colors.white,
          radius: .all(.circular(16.px)),
          padding: .all(20.px),
          raw: {'box-shadow': '0 1px 3px rgba(0,0,0,0.04)'},
        ),
        css('.ranking-header').styles(
          display: .flex,
          alignItems: .center,
          padding: .symmetric(horizontal: 16.px, vertical: 12.px),
          fontSize: 12.px,
          fontWeight: .w600,
          color: grey,
          raw: {'text-transform': 'uppercase', 'letter-spacing': '0.05em', 'border-bottom': '1px solid #F1F5F9'},
        ),
        css('.rh-rank').styles(width: 50.px),
        css('.rh-name').styles(raw: {'flex': '1'}),
        css('.rh-score').styles(width: 80.px, raw: {'text-align': 'right'}),
        css('.rh-trend').styles(width: 60.px, raw: {'text-align': 'right'}),
        // Rank rows
        css('.rank-row', [
          css('&').styles(
            display: .flex,
            alignItems: .center,
            padding: .symmetric(horizontal: 16.px, vertical: 14.px),
            radius: .all(.circular(10.px)),
            raw: {'transition': 'background 0.15s ease'},
          ),
          css('&:hover').styles(backgroundColor: scaffoldBg),
          css('.rank-num').styles(width: 50.px, fontWeight: .w700, fontSize: 14.px, color: secondaryDark),
          css('.rank-avatar').styles(
            width: 36.px,
            height: 36.px,
            radius: .all(.circular(18.px)),
            backgroundColor: baseHexColor,
            color: Colors.white,
            display: .flex,
            alignItems: .center,
            justifyContent: .center,
            fontWeight: .w600,
            fontSize: 14.px,
            raw: {'margin-right': '12px', 'flex-shrink': '0'},
          ),
          css('.rank-name').styles(raw: {'flex': '1'}, fontSize: 14.px, fontWeight: .w500, color: primaryDark),
          css('.rank-score').styles(width: 80.px, raw: {'text-align': 'right'}, fontSize: 14.px, fontWeight: .w600, color: primaryDark),
          css('.rank-trend').styles(width: 60.px, raw: {'text-align': 'right'}, fontSize: 13.px, fontWeight: .w500),
          css('.trend-up').styles(color: green),
          css('.trend-down').styles(color: red),
        ]),
      ];
}
