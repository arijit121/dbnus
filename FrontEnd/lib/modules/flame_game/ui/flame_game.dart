import 'package:flutter/material.dart';

import '../widget/boat_game.dart';
import 'package:flame/game.dart';

class FlameGame extends StatelessWidget {
  const FlameGame({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: BoatGame());
  }
}
