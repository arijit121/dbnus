import 'package:dbnus/utils/screen_utils.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flame/events.dart';

class BoatGame extends FlameGame with TapDetector {
  BoatGame({
    required this.widthState,
  });

  // late SpriteComponent background;
  // late SvgComponent boat;
  // late SvgComponent flag10;
  // late SvgComponent flag11;
  // late SvgComponent flag12;

  // // Text components for each flag
  // late TextComponent number10;
  // late TextComponent number11;
  // late TextComponent number12;

  // // Coordinates for the islands
  // final Vector2 island10Position = Vector2(100, 400);
  // final Vector2 island11Position = Vector2(200, 250);
  // final Vector2 island12Position = Vector2(300, 100);
  WidthState widthState;

  late SpriteComponent spriteComponent;

  int currentPoint = 0;

  final List<Vector2> points = [
    Vector2(ScreenUtils.nw() - 50, ScreenUtils.nh() - 50), // Point C
    Vector2(ScreenUtils.nw() - 50,
        (ScreenUtils.nh() - 50) - (ScreenUtils.nh() / 3)), // Point B
    Vector2(ScreenUtils.nw() - 50,
        (ScreenUtils.nh() - 50) - ((ScreenUtils.nh() / 3) * 2)), // Point A
  ];

  @override
  Color backgroundColor() => Colors.white;

  @override
  Future<void> onLoad() async {
    int extraBottom = widthState == WidthState.narrow ? 76 : 20;
    int extraSide = widthState == WidthState.large
        ? 292
        : widthState == WidthState.medium
            ? 96
            : 20;

    // Load and add background
    SpriteComponent background = SpriteComponent()
      ..sprite = Sprite(await images.load('boat_game_bg_img.jpg'))
      ..size = size;
    add(background);

// Add markers at each point
    for (final point in points) {
      Vector2 tempPoint = Vector2(point.x - extraSide, point.y - extraBottom);
      add(CircleComponent(
        radius: 10, // Size of the marker
        position: tempPoint, // Position of the marker
        paint: Paint()..color = Colors.red, // Color of the marker
      ));
    }

    Vector2 tempPoint = Vector2(points[currentPoint].x - extraSide,
        points[currentPoint].y - extraBottom);
    // Load the PNG sprite
    spriteComponent = SpriteComponent()
      ..sprite = await loadSprite('boat.png') // Path to your PNG file
      ..size = Vector2(50, 50)
      ..position = tempPoint; // Start at Point A
    add(spriteComponent);

    moveToNextPoint();

    //   // Load and position the boat (SVG)
    //   final boatSvg = await Svg.load("icon/boat.svg");
    //   boat = SvgComponent(
    //     svg: boatSvg,
    //     key: ComponentKey.named('boat'),
    //     size: Vector2(50, 50),
    //     position: island10Position.clone(),
    //   ); // Starting position of the boat add(boat);
    //   add(boat);

    //   final flagSvg = await loadSvg("icon/flag.svg");
    //   // Load and position flags at each island (SVG)
    //   flag10 = SvgComponent(
    //     svg: flagSvg,
    //     key: ComponentKey.named('flag10'),
    //   )
    //     ..size = Vector2(30, 30)
    //     ..position =
    //         island10Position + Vector2(10, -40); // Position above the island
    //   add(flag10);

    //   flag11 = SvgComponent(
    //     svg: flagSvg,
    //     key: ComponentKey.named('flag11'),
    //   )
    //     ..size = Vector2(30, 30)
    //     ..position = island11Position + Vector2(10, -40);
    //   add(flag11);

    //   flag12 = SvgComponent(
    //     svg: flagSvg,
    //     key: ComponentKey.named('flag12'),
    //   )
    //     ..size = Vector2(30, 30)
    //     ..position = island12Position + Vector2(10, -40);
    //   add(flag12);

    //   // Add numbers above each flag
    //   number10 = TextComponent(
    //     text: '10',
    //     position:
    //         flag10.position + Vector2(8, -20), // Adjust to center above flag
    //     textRenderer:
    //         TextPaint(style: TextStyle(color: Colors.white, fontSize: 16)),
    //   );
    //   add(number10);

    //   number11 = TextComponent(
    //     text: '11',
    //     position: flag11.position + Vector2(8, -20),
    //     textRenderer:
    //         TextPaint(style: TextStyle(color: Colors.white, fontSize: 16)),
    //   );
    //   add(number11);

    //   number12 = TextComponent(
    //     text: '12',
    //     position: flag12.position + Vector2(8, -20),
    //     textRenderer:
    //         TextPaint(style: TextStyle(color: Colors.white, fontSize: 16)),
    //   );
    //   add(number12);
  }

  void moveToNextPoint() {
    int extraBottom = widthState == WidthState.narrow ? 76 : 20;
    int extraSide = widthState == WidthState.large
        ? 292
        : widthState == WidthState.medium
            ? 96
            : 20;
    if (currentPoint >= points.length - 1) return;

    currentPoint++;
    Vector2 tempPoint = Vector2(points[currentPoint].x - extraSide,
        points[currentPoint].y - extraBottom);
    curveEffect(tempPoint);
  }

  void curveEffect(Vector2 targetPoint) {
    Vector2 targetPoint1 =
        Vector2(spriteComponent.x - 25, spriteComponent.y + 7);
    spriteComponent.add(
      MoveToEffect(
        targetPoint1,
        EffectController(duration: 2.5, curve: Curves.easeInOut),
        onComplete: () {
          Vector2 targetPoint2 =
              Vector2(spriteComponent.x - 12.5, spriteComponent.y - 7);

          spriteComponent.add(
            MoveToEffect(
              targetPoint2,
              EffectController(duration: 2.5, curve: Curves.easeInOut),
              onComplete: () {
                Vector2 targetPoint3 =
                    Vector2(spriteComponent.x - 12.5, spriteComponent.y - 20);

                spriteComponent.add(
                  MoveToEffect(
                    targetPoint3,
                    EffectController(duration: 2.5, curve: Curves.easeInOut),
                    onComplete: () {
                      spriteComponent.add(
                        MoveToEffect(
                          targetPoint, // Move to the next point
                          EffectController(
                              duration: 5, curve: Curves.easeInOut),
                          onComplete: () {
                            if (currentPoint < points.length - 1) {
                              moveToNextPoint(); // Move to the next point in sequence
                            }
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  // Method to move boat to a specific position with an animation
  // Future<void> moveBoatTo(Vector2 destination) async {
  //   boat.position.moveToTarget(destination, 2.0); // Move boat over 2 seconds
  // }

  // @override
  // void onTapUp(TapUpInfo info) {
  //   // Check where the user tapped and move the boat accordingly
  //   final tapPosition = info.eventPosition.global;

  //   if (flag10.containsPoint(tapPosition)) {
  //     moveBoatTo(island10Position);
  //   } else if (flag11.containsPoint(tapPosition)) {
  //     moveBoatTo(island11Position);
  //   } else if (flag12.containsPoint(tapPosition)) {
  //     moveBoatTo(island12Position);
  //   }
  // }
}
