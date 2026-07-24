import 'dart:math' as math;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';

import '../../../../navigation/custom_router/custom_route.dart';
import '../../../../shared/ui/atoms/buttons/custom_button.dart';
import '../../../../shared/ui/atoms/text/custom_text.dart';
import '../../../../shared/constants/color_const.dart';

/// Gravity Orbit — Tap to switch between inner and outer orbits.
/// Collect stardust and avoid asteroids.
/// Built with the Flame game engine.

class GravityOrbitPage extends StatelessWidget {
  const GravityOrbitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A12),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => CustomRoute.back(),
        ),
        title: const CustomText(
          'Gravity Orbit',
          color: Colors.white,
          fontWeight: FontWeight.w700,
          size: 20,
        ),
      ),
      body: GameWidget.controlled(
        gameFactory: GravityOrbitGame.new,
        overlayBuilderMap: {
          'GameOver': (context, game) =>
              _GameOverOverlay(game: game as GravityOrbitGame),
          'Tutorial': (context, game) =>
              _TutorialOverlay(game: game as GravityOrbitGame),
        },
        initialActiveOverlays: const ['Tutorial'],
      ),
    );
  }
}

class _TutorialOverlay extends StatelessWidget {
  final GravityOrbitGame game;
  const _TutorialOverlay({required this.game});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        game.overlays.remove('Tutorial');
        game.resumeEngine();
      },
      child: Container(
        color: Colors.black.withValues(alpha: 0.7),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.touch_app, color: Colors.white, size: 64),
              const SizedBox(height: 16),
              const CustomText(
                'Tap to Switch Orbits',
                color: Colors.white,
                size: 24,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 8),
              const CustomText(
                'Collect Gems, Avoid Asteroids',
                color: Colors.white70,
                size: 16,
              ),
              const SizedBox(height: 32),
              const CustomText(
                'TAP TO START',
                color: ColorConst.vibrateBlue,
                size: 20,
                fontWeight: FontWeight.w900,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GameOverOverlay extends StatelessWidget {
  final GravityOrbitGame game;
  const _GameOverOverlay({required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        margin: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E).withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFFF0080).withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF0080).withValues(alpha: 0.2),
              blurRadius: 30,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CustomText('🪐', size: 48),
            const SizedBox(height: 16),
            const CustomText(
              'ORBIT DECAYED',
              color: Color(0xFFFF0080),
              size: 28,
              fontWeight: FontWeight.w800,
            ),
            const SizedBox(height: 8),
            CustomText(
              'Score: ${game.score}',
              color: Colors.white,
              size: 20,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 24),
            CustomGOEButton(
              onPressed: () {
                game.restart();
              },
              backGroundColor: ColorConst.vibrateBlue,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              borderRadius: BorderRadius.circular(14),
              child: const CustomText('RESTART MISSION',
                  color: Colors.white, fontWeight: FontWeight.w700, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class GravityOrbitGame extends FlameGame
    with TapCallbacks, HasCollisionDetection {
  int score = 0;
  bool isGameOver = false;
  late _Player player;
  late TextComponent scoreText;

  final double innerRadius = 80;
  final double outerRadius = 160;

  double spawnTimer = 0;
  double spawnInterval = 2.0;

  @override
  void onMount() {
    super.onMount();
    pauseEngine();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Background Stars
    add(_BackgroundStars());

    // Central Sun
    add(_Sun());

    // Orbits Visuals
    add(_OrbitRing(radiusValue: innerRadius));
    add(_OrbitRing(radiusValue: outerRadius));

    // Player
    player = _Player(
      innerRadius: innerRadius,
      outerRadius: outerRadius,
    );
    add(player);

    // Score UI
    scoreText = TextComponent(
      text: 'Score: 0',
      position: Vector2(20, 20),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    add(scoreText);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isGameOver) return;

    spawnTimer += dt;
    if (spawnTimer >= spawnInterval) {
      spawnTimer = 0;
      _spawnEntity();
      // Slowly increase difficulty
      spawnInterval = (spawnInterval * 0.99).clamp(0.6, 2.0);
    }
  }

  void _spawnEntity() {
    final random = math.Random();
    final isAsteroid = random.nextDouble() > 0.4;
    final onInnerOrbit = random.nextBool();
    final radius = onInnerOrbit ? innerRadius : outerRadius;
    
    // Spawn at a random angle outside the view or far away
    final startAngle = random.nextDouble() * math.pi * 2;
    
    if (isAsteroid) {
      add(_Asteroid(radius: radius, startAngle: startAngle));
    } else {
      add(_Stardust(radius: radius, startAngle: startAngle));
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (isGameOver) return;
    player.switchOrbit();
  }

  void incrementScore() {
    score += 10;
    scoreText.text = 'Score: $score';
    
    // Visual feedback on score
    scoreText.add(
      ScaleEffect.to(
        Vector2.all(1.2),
        EffectController(duration: 0.1, alternate: true),
      ),
    );
  }

  void gameOver() {
    if (isGameOver) return;
    isGameOver = true;
    overlays.add('GameOver');
    pauseEngine();
  }

  void restart() {
    score = 0;
    scoreText.text = 'Score: 0';
    isGameOver = false;
    overlays.remove('GameOver');
    
    // Clear asteroids and stardust
    children.whereType<_Asteroid>().forEach((e) => e.removeFromParent());
    children.whereType<_Stardust>().forEach((e) => e.removeFromParent());
    
    player.reset();
    resumeEngine();
  }
}

class _Sun extends CircleComponent with HasGameRef<GravityOrbitGame> {
  _Sun() : super(anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    position = gameRef.size / 2;
    radius = 30;
    paint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.yellow,
          Colors.orange.withValues(alpha: 0.8),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: 40));
    
    // Pulsing effect
    add(
      ScaleEffect.to(
        Vector2.all(1.2),
        EffectController(duration: 1.5, alternate: true, infinite: true),
      ),
    );
  }
}

class _OrbitRing extends CircleComponent with HasGameRef<GravityOrbitGame> {
  final double radiusValue;
  _OrbitRing({required this.radiusValue}) : super(anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    position = gameRef.size / 2;
    radius = radiusValue;
    paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
  }
}

class _Player extends CircleComponent 
    with HasGameRef<GravityOrbitGame>, CollisionCallbacks {
  final double innerRadius;
  final double outerRadius;
  
  double currentRadius;
  double angle = 0;
  final double speed = 2.0;

  _Player({required this.innerRadius, required this.outerRadius})
      : currentRadius = innerRadius,
        super(anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    radius = 8;
    paint = Paint()
      ..color = ColorConst.vibrateBlue
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    add(CircleHitbox());
    
    // Trail effect could be added here
  }

  @override
  void update(double dt) {
    super.update(dt);
    angle += speed * dt;
    
    final center = gameRef.size / 2;
    position = center + Vector2(
      math.cos(angle) * currentRadius,
      math.sin(angle) * currentRadius,
    );
  }

  void switchOrbit() {
    currentRadius = (currentRadius == innerRadius) ? outerRadius : innerRadius;
    
    // Visual pop on switch
    add(
      ScaleEffect.to(
        Vector2.all(1.5),
        EffectController(duration: 0.1, alternate: true),
      ),
    );
  }

  void reset() {
    angle = 0;
    currentRadius = innerRadius;
  }
}

class _Asteroid extends CircleComponent 
    with HasGameRef<GravityOrbitGame>, CollisionCallbacks {
  final double orbitRadius;
  double angle;
  final double speed;

  _Asteroid({required double radius, required double startAngle})
      : orbitRadius = radius,
        angle = startAngle,
        speed = 1.0 + math.Random().nextDouble() * 1.5,
        super(anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    radius = 12;
    paint = Paint()..color = const Color(0xFFFF0080);
    
    // Glow
    add(CircleHitbox());
    
    add(
      ColorEffect(
        const Color(0xFFFF8000),
        EffectController(duration: 0.5, alternate: true, infinite: true),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Asteroids move in opposite direction or different speed
    angle -= speed * dt;
    
    final center = gameRef.size / 2;
    position = center + Vector2(
      math.cos(angle) * orbitRadius,
      math.sin(angle) * orbitRadius,
    );
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is _Player) {
      gameRef.gameOver();
    }
  }
}

class _Stardust extends CircleComponent 
    with HasGameRef<GravityOrbitGame>, CollisionCallbacks {
  final double orbitRadius;
  double angle;

  _Stardust({required double radius, required double startAngle})
      : orbitRadius = radius,
        angle = startAngle,
        super(anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    radius = 6;
    paint = Paint()..color = Colors.cyanAccent;
    add(CircleHitbox());
    
    add(
      OpacityEffect.to(
        0.3,
        EffectController(duration: 0.4, alternate: true, infinite: true),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Stardust is static on orbit relative to center? 
    // No, let's keep them moving slowly so they are catchable
    angle += 0.5 * dt;
    
    final center = gameRef.size / 2;
    position = center + Vector2(
      math.cos(angle) * orbitRadius,
      math.sin(angle) * orbitRadius,
    );
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is _Player) {
      gameRef.incrementScore();
      removeFromParent();
    }
  }
}

class _BackgroundStars extends Component with HasGameRef<GravityOrbitGame> {
  final List<Offset> stars = [];
  final List<double> opacities = [];
  final random = math.Random();

  @override
  Future<void> onLoad() async {
    for (int i = 0; i < 100; i++) {
      stars.add(Offset(
        random.nextDouble() * gameRef.size.x,
        random.nextDouble() * gameRef.size.y,
      ));
      opacities.add(random.nextDouble());
    }
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.white;
    for (int i = 0; i < stars.length; i++) {
      paint.color = Colors.white.withValues(alpha: opacities[i] * 0.5);
      canvas.drawCircle(stars[i], 1, paint);
    }
  }
}
