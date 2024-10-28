import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flame/events.dart';

class BoatGame extends FlameGame with TapDetector {
  late SpriteComponent background;
  late SvgComponent boat;
  late SvgComponent flag10;
  late SvgComponent flag11;
  late SvgComponent flag12;

  // Text components for each flag
  late TextComponent number10;
  late TextComponent number11;
  late TextComponent number12;

  // Coordinates for the islands
  final Vector2 island10Position = Vector2(100, 400);
  final Vector2 island11Position = Vector2(200, 250);
  final Vector2 island12Position = Vector2(300, 100);

  @override
  Future<void> onLoad() async {
    // Load and add background
    background = SpriteComponent()
      ..sprite = Sprite(await images.load('boat_game_bg_img.png'))
      ..size = size;
    add(background);

    // Load and position the boat (SVG)
    final boatSvg = await Svg.load("icon/boat.svg");
    boat = SvgComponent(
      svg: boatSvg,
      key: ComponentKey.named('boat'),
      size: Vector2(50, 50),
      position: island10Position.clone(),
    ); // Starting position of the boat add(boat);
    add(boat);

    final flagSvg = await loadSvg("icon/flag.svg");
    // Load and position flags at each island (SVG)
    flag10 = SvgComponent(
      svg: flagSvg,
      key: ComponentKey.named('flag10'),
    )
      ..size = Vector2(30, 30)
      ..position =
          island10Position + Vector2(10, -40); // Position above the island
    add(flag10);

    flag11 = SvgComponent(
      svg: flagSvg,
      key: ComponentKey.named('flag11'),
    )
      ..size = Vector2(30, 30)
      ..position = island11Position + Vector2(10, -40);
    add(flag11);

    flag12 = SvgComponent(
      svg: flagSvg,
      key: ComponentKey.named('flag12'),
    )
      ..size = Vector2(30, 30)
      ..position = island12Position + Vector2(10, -40);
    add(flag12);

    // Add numbers above each flag
    number10 = TextComponent(
      text: '10',
      position:
          flag10.position + Vector2(8, -20), // Adjust to center above flag
      textRenderer:
          TextPaint(style: TextStyle(color: Colors.white, fontSize: 16)),
    );
    add(number10);

    number11 = TextComponent(
      text: '11',
      position: flag11.position + Vector2(8, -20),
      textRenderer:
          TextPaint(style: TextStyle(color: Colors.white, fontSize: 16)),
    );
    add(number11);

    number12 = TextComponent(
      text: '12',
      position: flag12.position + Vector2(8, -20),
      textRenderer:
          TextPaint(style: TextStyle(color: Colors.white, fontSize: 16)),
    );
    add(number12);
  }

  // Method to move boat to a specific position with an animation
  Future<void> moveBoatTo(Vector2 destination) async {
    boat.position.moveToTarget(destination, 2.0); // Move boat over 2 seconds
  }

  @override
  void onTapUp(TapUpInfo info) {
    // Check where the user tapped and move the boat accordingly
    final tapPosition = info.eventPosition.global;

    if (flag10.containsPoint(tapPosition)) {
      moveBoatTo(island10Position);
    } else if (flag11.containsPoint(tapPosition)) {
      moveBoatTo(island11Position);
    } else if (flag12.containsPoint(tapPosition)) {
      moveBoatTo(island12Position);
    }
  }
}
