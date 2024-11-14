import 'package:dbnus/utils/screen_utils.dart';
import 'package:flutter/material.dart';

import 'package:flame/game.dart';

import '../widget/scrolling_background_game.dart';

class FlameGame extends StatelessWidget {
  const FlameGame({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, widthState) {
      return GameWidgetWithGesture(
          game: SingleScrollBackgroundGame(
        widthState: widthState,
      ));
    });
  }
}
