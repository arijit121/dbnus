import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:dbnus/navigation/custom_router/custom_route.dart';
import 'package:dbnus/navigation/router_name.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

class FlameGame extends StatelessWidget {
  const FlameGame({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                24.ph,
                _buildSectionTitle('Games', FeatherIcons.play),
                12.ph,
                _buildGamesGrid(context),
                24.ph,
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1D2E), Color(0xFF2D3250)],
        ),
        boxShadow: [
          BoxShadow(
            color: ColorConst.sidebarBg.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(FeatherIcons.zap, color: Colors.white, size: 26),
          ),
          16.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  'Game Center',
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  size: 22,
                ),
                4.ph,
                CustomText(
                  'Choose a game and have fun!',
                  color: Colors.white.withValues(alpha: 0.7),
                  size: 13,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FF).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: const Color(0xFF6C63FF).withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(FeatherIcons.grid,
                    color: Color(0xFF6C63FF), size: 14),
                6.pw,
                const CustomText('4',
                    color: Color(0xFF6C63FF),
                    fontWeight: FontWeight.w700,
                    size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: ColorConst.primaryDark),
        10.pw,
        CustomText(title,
            fontWeight: FontWeight.w600,
            size: 18,
            color: ColorConst.primaryDark),
      ],
    );
  }

  Widget _buildGamesGrid(BuildContext context) {
    final games = [
      _GameEntry(
        title: 'Tic Tac Toe',
        subtitle: 'Classic X & O battle',
        icon: Icons.grid_3x3_rounded,
        gradient: [const Color(0xFF6C63FF), ColorConst.sidebarSelected],
        routeName: RouteName.ticTacToe,
      ),
      _GameEntry(
        title: 'Memory Match',
        subtitle: 'Find color pairs',
        icon: Icons.dashboard_rounded,
        gradient: [const Color(0xFF4ECDC4), const Color(0xFF44B09E)],
        routeName: RouteName.colorMatch,
      ),
      _GameEntry(
        title: 'Snake',
        subtitle: 'Eat & grow longer',
        icon: Icons.pest_control_rounded,
        gradient: [const Color(0xFFFF6B6B), const Color(0xFFEE5A24)],
        routeName: RouteName.snakeGame,
      ),
      _GameEntry(
        title: 'Reaction Time',
        subtitle: 'Test your reflexes',
        icon: Icons.flash_on_rounded,
        gradient: [const Color(0xFFFFE66D), const Color(0xFFF38181)],
        routeName: RouteName.reactionTime,
      ),
    ];

    return LayoutBuilder(builder: (context, constraints) {
      int crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.1,
        ),
        itemCount: games.length,
        itemBuilder: (context, index) {
          final game = games[index];
          return _buildGameCard(context, game);
        },
      );
    });
  }

  Widget _buildGameCard(BuildContext context, _GameEntry game) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          CustomRoute.navigateNamed(game.routeName);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: game.gradient,
            ),
            boxShadow: [
              BoxShadow(
                color: game.gradient.first.withValues(alpha: 0.35),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(game.icon, color: Colors.white, size: 24),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    game.title,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    size: 15,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  2.ph,
                  CustomText(
                    game.subtitle,
                    color: Colors.white.withValues(alpha: 0.8),
                    size: 11,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GameEntry {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  final String routeName;

  const _GameEntry({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.routeName,
  });
}
