import 'package:flutter/material.dart';
import 'package:dbnus/shared/extensions/spacing.dart';

import '../widgets/leaderboard_header.dart';
import '../widgets/quick_actions.dart';
import '../widgets/ranking_list.dart';

class LeaderBoard extends StatefulWidget {
  const LeaderBoard({super.key});

  @override
  State<LeaderBoard> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Header ──────────────────────────────────────────
        const LeaderboardHeader(),
        16.ph,

        // ── Quick Actions ───────────────────────────────────
        const QuickActions(),
        16.ph,

        // ── Reorderable List ────────────────────────────────
        const Expanded(
          child: RankingList(),
        ),
      ],
    );
  }
}
