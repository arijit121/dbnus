import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';

import '../../../../navigation/custom_router/custom_route.dart';

/// Space Shooter — Tap to destroy falling asteroids before they reach the bottom.
/// Built with the Flame game engine.

class SpaceShooterPage extends StatelessWidget {
  const SpaceShooterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => CustomRoute.back(),
        ),
        title: const Text(
          'Space Shooter',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20),
        ),
      ),
      body: GameWidget.controlled(
        gameFactory: SpaceShooterGame.new,
        overlayBuilderMap: {
          'GameOver': (context, game) =>
              _GameOverOverlay(game: game as SpaceShooterGame),
        },
      ),
    );
  }
}

class _GameOverOverlay extends StatelessWidget {
  final SpaceShooterGame game;
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
          border:
              Border.all(color: const Color(0xFFFF6B6B).withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF6B6B).withValues(alpha: 0.2),
              blurRadius: 30,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('💥', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            const Text(
              'Game Over',
              style: TextStyle(
                  color: Color(0xFFFF6B6B),
                  fontSize: 28,
                  fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              'Score: ${game.score}',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                game.restart();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Play Again',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

class SpaceShooterGame extends FlameGame
    with TapCallbacks, HasCollisionDetection {
  final Random _random = Random();
  late TextComponent _scoreText;
  late TextComponent _livesText;
  int score = 0;
  int lives = 3;
  double _spawnTimer = 0;
  double _spawnInterval = 1.5;
  double _difficultyTimer = 0;
  bool _gameOver = false;

  @override
  Color backgroundColor() => const Color(0xFF0F0E17);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Add screen boundary for collision
    add(ScreenHitbox());

    // Score display
    _scoreText = TextComponent(
      text: 'Score: 0',
      position: Vector2(16, 16),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFF4ECDC4),
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
    add(_scoreText);

    // Lives display
    _livesText = TextComponent(
      text: '❤️ ❤️ ❤️',
      position: Vector2(size.x - 16, 16),
      anchor: Anchor.topRight,
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 18),
      ),
    );
    add(_livesText);

    // Spawn initial stars
    for (int i = 0; i < 50; i++) {
      add(_Star(
        position: Vector2(
          _random.nextDouble() * size.x,
          _random.nextDouble() * size.y,
        ),
        speed: 20 + _random.nextDouble() * 60,
      ));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_gameOver) return;

    _spawnTimer += dt;
    _difficultyTimer += dt;

    // Increase difficulty over time
    if (_difficultyTimer > 10) {
      _difficultyTimer = 0;
      _spawnInterval = (_spawnInterval * 0.85).clamp(0.3, 1.5);
    }

    // Spawn asteroids
    if (_spawnTimer >= _spawnInterval) {
      _spawnTimer = 0;
      _spawnAsteroid();
    }
  }

  void _spawnAsteroid() {
    final asteroidSize = 30.0 + _random.nextDouble() * 40;
    final x = asteroidSize + _random.nextDouble() * (size.x - asteroidSize * 2);
    final speed = 80.0 + _random.nextDouble() * 120 + score * 0.5;

    add(_Asteroid(
      position: Vector2(x, -asteroidSize),
      asteroidSize: asteroidSize,
      speed: speed,
      game: this,
    ));
  }

  void addScore(int points) {
    score += points;
    _scoreText.text = 'Score: $score';
  }

  void loseLife() {
    lives--;
    final hearts = List.generate(lives, (_) => '❤️').join(' ');
    _livesText.text = hearts.isEmpty ? '💔' : hearts;

    if (lives <= 0) {
      _gameOver = true;
      overlays.add('GameOver');
    }
  }

  void restart() {
    overlays.remove('GameOver');
    _gameOver = false;
    score = 0;
    lives = 3;
    _spawnTimer = 0;
    _spawnInterval = 1.5;
    _difficultyTimer = 0;
    _scoreText.text = 'Score: 0';
    _livesText.text = '❤️ ❤️ ❤️';

    // Remove all asteroids and explosions
    children
        .whereType<_Asteroid>()
        .toList()
        .forEach((a) => a.removeFromParent());
    children
        .whereType<_Explosion>()
        .toList()
        .forEach((e) => e.removeFromParent());
  }
}

class _Star extends CircleComponent {
  final double speed;

  _Star({required super.position, required this.speed})
      : super(
          radius: 1 + Random().nextDouble() * 1.5,
          paint: Paint()
            ..color = Colors.white
                .withValues(alpha: 0.2 + Random().nextDouble() * 0.5),
        );

  @override
  void update(double dt) {
    super.update(dt);
    y += speed * dt;

    if (y > (findGame()?.size.y ?? 800)) {
      y = -5;
      x = Random().nextDouble() * (findGame()?.size.x ?? 400);
    }
  }
}

class _Asteroid extends CircleComponent with TapCallbacks {
  final double speed;
  final double asteroidSize;
  final SpaceShooterGame game;
  late Paint _glowPaint;
  bool _destroyed = false;

  _Asteroid({
    required super.position,
    required this.asteroidSize,
    required this.speed,
    required this.game,
  }) : super(
          radius: asteroidSize / 2,
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Main color based on size
    final hue = Random().nextDouble() * 60 + 10; // warm colors
    final color = HSLColor.fromAHSL(1.0, hue, 0.7, 0.5).toColor();

    paint = Paint()..color = color;
    _glowPaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    // Add hitbox for tap detection
    add(CircleHitbox());

    // Subtle rotation
    add(RotateEffect.by(
      Random().nextDouble() * 4 - 2,
      InfiniteEffectController(LinearEffectController(3)),
    ));
  }

  @override
  void render(Canvas canvas) {
    // Glow effect
    canvas.drawCircle(Offset.zero, radius * 1.3, _glowPaint);
    super.render(canvas);

    // Inner detail circles
    final detailPaint = Paint()..color = Colors.black.withValues(alpha: 0.2);
    canvas.drawCircle(
      Offset(radius * 0.2, -radius * 0.2),
      radius * 0.3,
      detailPaint,
    );
    canvas.drawCircle(
      Offset(-radius * 0.3, radius * 0.3),
      radius * 0.2,
      detailPaint,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_destroyed) return;

    y += speed * dt;

    // Check if asteroid reached bottom
    if (y > game.size.y + asteroidSize) {
      game.loseLife();
      removeFromParent();
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (_destroyed) return;
    _destroyed = true;

    // Points based on size (smaller = more points)
    final points = (100 / (asteroidSize / 30)).round();
    game.addScore(points);

    // Spawn explosion
    game.add(
        _Explosion(position: position.clone(), explosionSize: asteroidSize));

    removeFromParent();
  }
}

class _Explosion extends PositionComponent {
  final double explosionSize;
  double _lifetime = 0;
  static const double _maxLifetime = 0.5;

  _Explosion({required super.position, required this.explosionSize})
      : super(anchor: Anchor.center);

  @override
  void update(double dt) {
    super.update(dt);
    _lifetime += dt;
    if (_lifetime >= _maxLifetime) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final progress = _lifetime / _maxLifetime;
    final radius = explosionSize * (0.5 + progress * 1.5);
    final alpha = (1.0 - progress).clamp(0.0, 1.0);

    // Outer glow
    canvas.drawCircle(
      Offset.zero,
      radius * 1.5,
      Paint()
        ..color = const Color(0xFFFF6B6B).withValues(alpha: alpha * 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );

    // Main explosion
    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()..color = const Color(0xFFFFE66D).withValues(alpha: alpha * 0.8),
    );

    // Core
    canvas.drawCircle(
      Offset.zero,
      radius * 0.4,
      Paint()..color = Colors.white.withValues(alpha: alpha),
    );

    // Particles
    final particleCount = 8;
    for (int i = 0; i < particleCount; i++) {
      final angle = (i / particleCount) * 2 * pi;
      final particleRadius = radius * (1.0 + progress * 0.8);
      final px = cos(angle) * particleRadius;
      final py = sin(angle) * particleRadius;
      canvas.drawCircle(
        Offset(px, py),
        3 * (1 - progress),
        Paint()..color = const Color(0xFFFF6B6B).withValues(alpha: alpha),
      );
    }
  }
}
