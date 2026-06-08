import 'package:jaspr/dom.dart' hide BorderRadius, Alignment;
import 'package:jaspr/jaspr.dart';
import '../../shared/constants/theme.dart';
import '../../shared/ui/ui.dart';

class LeaderBoardPage extends StatefulComponent {
  const LeaderBoardPage({super.key});

  @override
  State<LeaderBoardPage> createState() => _LeaderBoardPageState();
}

class _LeaderBoardPageState extends State<LeaderBoardPage> {
  final List<Map<String, dynamic>> _players = [
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
    return Column(
      gap: 24,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText('🏆 Leader Board', variant: TextVariant.h2),
                CustomText('Top performers this season', variant: TextVariant.bodySmall),
              ],
            ),
            CustomButton(
              label: 'Refresh',
              icon: '🔄',
              onPressed: () {
                setState(() {});
              },
            ),
          ],
        ),

        // Stats overview grid
        GridView(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          shrinkWrap: true,
          children: [
            _statCard('🏆', 'Active Season', 'Season 10'),
            _statCard('👥', 'Total Players', '1,234'),
            _statCard('💰', 'Prize Pool', '\$5,000'),
          ],
        ),

        // Top 3 podium
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          gap: 16,
          className: 'podium',
          children: [
            _podiumCard(_players[1], 'silver'),
            _podiumCard(_players[0], 'gold'),
            _podiumCard(_players[2], 'bronze'),
          ],
        ),

        // Full ranking list
        Card(
          className: 'ranking-card',
          padding: const EdgeInsets.all(20.0),
          borderRadius: const BorderRadius.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                className: 'ranking-header',
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomText('#', className: 'rh-rank', variant: TextVariant.label),
                    CustomText('Player', className: 'rh-name', variant: TextVariant.label),
                    CustomText('Score', className: 'rh-score', variant: TextVariant.label),
                    CustomText('Trend', className: 'rh-trend', variant: TextVariant.label),
                  ],
                ),
              ),
              ListView.separated(
                itemCount: _players.length,
                shrinkWrap: true,
                itemBuilder: (context, index) => _rankRow(_players[index]),
                separatorBuilder: (context, index) => const CustomDivider(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Component _statCard(String icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      gap: 12,
      children: [
        Container(
          className: 'lb-stat-icon',
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(12.0),
          ),
          child: CustomText(icon, variant: TextVariant.h3),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(label, variant: TextVariant.bodySmall, color: secondaryDark),
            CustomText(value, variant: TextVariant.h3, fontWeight: FontWeight.w700),
          ],
        ),
      ],
    );
  }

  Component _podiumCard(Map<String, dynamic> player, String tier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      className: 'podium-card podium-$tier',
      gap: 8,
      children: [
        CustomText(player['icon'] as String, className: 'podium-medal', variant: TextVariant.h1),
        CustomText(player['name'] as String, variant: TextVariant.body, fontWeight: FontWeight.w600),
        CustomText('${player['score']} pts', variant: TextVariant.bodySmall, color: secondaryDark),
      ],
    );
  }

  Component _rankRow(Map<String, dynamic> player) {
    final rank = player['rank'] as int;
    final isTop3 = rank <= 3;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      className: 'rank-row ${isTop3 ? "rank-top" : ""}',
      children: [
        CustomText('${player['rank']}', className: 'rank-num', fontWeight: FontWeight.w700),
        Container(
          className: 'rank-avatar',
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(18.0),
          ),
          child: CustomText(((player['name'] as String)[0]), fontWeight: FontWeight.w600, color: Colors.white),
        ),
        CustomText(player['name'] as String, className: 'rank-name', fontWeight: FontWeight.w500),
        CustomText('${player['score']}', className: 'rank-score', fontWeight: FontWeight.w600),
        CustomText(
          player['trend'] as String,
          className: 'rank-trend ${(player['trend'] as String).startsWith('+') ? "trend-up" : "trend-down"}',
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }
}
