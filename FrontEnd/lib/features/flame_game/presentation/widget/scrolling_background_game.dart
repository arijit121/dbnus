import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';

import 'package:dbnus/shared/utils/screen_utils.dart';

// The game class that handles background scrolling.
class SingleScrollBackgroundGame extends FlameGame {
  SingleScrollBackgroundGame({required this.widthState});

  WidthState widthState;
  late SpriteComponent background1;
  late SpriteComponent background2;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Load two backgrounds
    background1 = SpriteComponent()
      ..sprite = await loadSprite('back_ground_1.jpg')
      ..size = Vector2(
          size.x, size.y * 2); // Twice the height for vertical scrolling
    background2 = SpriteComponent()
      ..sprite = await loadSprite('back_ground_2.jpg')
      ..size = Vector2(size.x, size.y * 2); // Same size as the first background

    // Set initial positions
    background2.y = -size.y; // Position second background off-screen

    add(background1);
    add(background2);
  }

  // Method to update the background positions based on drag movement.
  void manualScroll(double deltaY) {
    background1.y += deltaY;
    background2.y += deltaY;

    // Infinite scroll: reset position once the backgrounds are off-screen.
    if (background1.y >= size.y) {
      background1.y = -size.y; // Reset to the top
    } else if (background1.y <= -size.y) {
      background1.y = size.y; // Reset to the bottom if off-screen upwards
    }

    if (background2.y >= size.y) {
      background2.y = -size.y; // Reset to the top
    } else if (background2.y <= -size.y) {
      background2.y = size.y; // Reset to the bottom if off-screen upwards
    }
  }
}

// Widget that handles the gesture detection and passes the drag data to the game.
class GameWidgetWithGesture extends StatelessWidget {
  final SingleScrollBackgroundGame game;

  const GameWidgetWithGesture({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        game.manualScroll(details.primaryDelta!); // Update background position.
      },
      child: GameWidget(game: game), // Embed the Flame game widget.
    );
  }
}
