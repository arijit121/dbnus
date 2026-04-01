import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:dbnus/shared/ui/organisms/grids/custom_grid_view.dart';
import 'package:dbnus/navigation/custom_router/custom_route.dart';
import 'package:dbnus/navigation/router_name.dart';
import 'package:flutter/material.dart';

class GameEntry {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  final String routeName;

  const GameEntry({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.routeName,
  });
}

class GameDashboardGrid extends StatelessWidget {
  const GameDashboardGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final games = [
      GameEntry(
        title: 'Tic Tac Toe',
        subtitle: 'Classic X & O battle',
        icon: Icons.grid_3x3_rounded,
        gradient: [const Color(0xFF6C63FF), ColorConst.sidebarSelected],
        routeName: RouteName.ticTacToe,
      ),
      GameEntry(
        title: 'Memory Match',
        subtitle: 'Find color pairs',
        icon: Icons.dashboard_rounded,
        gradient: [const Color(0xFF4ECDC4), const Color(0xFF44B09E)],
        routeName: RouteName.colorMatch,
      ),
      GameEntry(
        title: 'Snake',
        subtitle: 'Eat & grow longer',
        icon: Icons.pest_control_rounded,
        gradient: [const Color(0xFFFF6B6B), const Color(0xFFEE5A24)],
        routeName: RouteName.snakeGame,
      ),
      GameEntry(
        title: 'Reaction Time',
        subtitle: 'Test your reflexes',
        icon: Icons.flash_on_rounded,
        gradient: [const Color(0xFFFFE66D), const Color(0xFFF38181)],
        routeName: RouteName.reactionTime,
      ),
      GameEntry(
        title: 'Space Shooter',
        subtitle: 'Destroy asteroids!',
        icon: Icons.rocket_launch_rounded,
        gradient: [const Color(0xFF8E44AD), const Color(0xFF6C3483)],
        routeName: RouteName.spaceShooter,
      ),
      GameEntry(
        title: 'Brick Breaker',
        subtitle: 'Break all bricks!',
        icon: Icons.sports_tennis_rounded,
        gradient: [const Color(0xFF2980B9), const Color(0xFF1A5276)],
        routeName: RouteName.brickBreaker,
      ),
      GameEntry(
        title: 'Gravity Orbit',
        subtitle: 'Switch orbits to survive',
        icon: Icons.blur_circular_rounded,
        gradient: [const Color(0xFF6C63FF), const Color(0xFFFF0080)],
        routeName: RouteName.gravityOrbit,
      ),
    ];

    return LayoutBuilder(builder: (context, constraints) {
      int crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
      return CustomGridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        separatorBuilder: (context, index) => 12.ph,
        itemCount: games.length,
        builder: (context, index) {
          final game = games[index];
          return AspectRatio(
            aspectRatio: 1.1,
            child: GameCard(game: game),
          );
        },
      );
    });
  }
}

class GameCard extends StatelessWidget {
  final GameEntry game;

  const GameCard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
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
