import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/features/game/presentation/widget/game_dashboard_header.dart';
import 'package:dbnus/features/game/presentation/widget/game_dashboard_grid.dart';
import 'package:dbnus/features/game/presentation/widget/game_section_title.dart';
import 'package:dbnus/shared/constants/assects_const.dart';
import 'package:flutter/material.dart';

class GameDashboard extends StatelessWidget {
  const GameDashboard({super.key});

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
                const GameDashboardHeader(),
                24.ph,
                const GameSectionTitle(title: 'Games', icon: AssetsConst.featherPlay),
                12.ph,
                const GameDashboardGrid(),
                24.ph,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
