import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';

import '../../../../navigation/custom_router/custom_route.dart';

/// Brick Breaker — Classic paddle-and-ball game built with the Flame engine.
/// Drag the paddle to bounce the ball and break all bricks.

class BrickBreakerPage extends StatelessWidget {
  const BrickBreakerPage({super.key});

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
          'Brick Breaker',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20),
        ),
      ),
      body: GameWidget.controlled(
        gameFactory: BrickBreakerFlameGame.new,
        overlayBuilderMap: {
          'GameOver': (context, game) =>
              _OverlayWidget(game: game as BrickBreakerFlameGame, won: false),
          'Win': (context, game) =>
              _OverlayWidget(game: game as BrickBreakerFlameGame, won: true),
          'Tap': (context, game) =>
              _TapToStartOverlay(game: game as BrickBreakerFlameGame),
        },
        initialActiveOverlays: const ['Tap'],
      ),
    );
  }
}

class _TapToStartOverlay extends StatelessWidget {
  final BrickBreakerFlameGame game;
  const _TapToStartOverlay({required this.game});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        game.startGame();
        game.overlays.remove('Tap');
      },
      child: Container(
        color: Colors.transparent,
        child: const Center(
          child: Text(
            'Tap to Start',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _OverlayWidget extends StatelessWidget {
  final BrickBreakerFlameGame game;
  final bool won;
  const _OverlayWidget({required this.game, required this.won});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        margin: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E).withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: won
                ? const Color(0xFF4ECDC4).withValues(alpha: 0.5)
                : const Color(0xFFFF6B6B).withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(won ? '🎉' : '💥', style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text(
              won ? 'You Win!' : 'Game Over',
              style: TextStyle(
                color: won ? const Color(0xFF4ECDC4) : const Color(0xFFFF6B6B),
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
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
              onPressed: () => game.restart(),
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

class BrickBreakerFlameGame extends FlameGame
    with HasCollisionDetection, PanDetector {
  late _Paddle paddle;
  late _Ball ball;
  late TextComponent scoreText;
  int score = 0;
  int _brickCount = 0;
  bool _started = false;

  @override
  Color backgroundColor() => const Color(0xFF0F0E17);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _setupGame();
  }

  void _setupGame() {
    // Paddle
    paddle = _Paddle(
      gameSize: size,
      position: Vector2(size.x / 2, size.y - 60),
    );
    add(paddle);

    // Ball (starts on paddle)
    ball = _Ball(
      position: Vector2(size.x / 2, size.y - 80),
      gameRef: this,
    );
    add(ball);

    // Score
    scoreText = TextComponent(
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
    add(scoreText);

    // Bricks
    _createBricks();

    // Walls
    add(_Wall(position: Vector2(0, 0), wallSize: Vector2(size.x, 4))); // top
    add(_Wall(position: Vector2(0, 0), wallSize: Vector2(4, size.y))); // left
    add(_Wall(
        position: Vector2(size.x - 4, 0),
        wallSize: Vector2(4, size.y))); // right
  }

  void _createBricks() {
    const rows = 5;
    const cols = 7;
    const brickPadding = 6.0;
    final brickWidth = (size.x - brickPadding * (cols + 1)) / cols;
    const brickHeight = 24.0;

    final colors = [
      const Color(0xFFFF6B6B),
      const Color(0xFFFFE66D),
      const Color(0xFF4ECDC4),
      const Color(0xFF6C63FF),
      const Color(0xFFF38181),
    ];

    _brickCount = 0;
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final x = brickPadding + col * (brickWidth + brickPadding);
        final y = 60.0 + row * (brickHeight + brickPadding);
        add(_Brick(
          position: Vector2(x, y),
          brickSize: Vector2(brickWidth, brickHeight),
          color: colors[row % colors.length],
          points: (rows - row) * 10,
          gameRef: this,
        ));
        _brickCount++;
      }
    }
  }

  void startGame() {
    _started = true;
    ball.launch();
  }

  void addScore(int points) {
    score += points;
    scoreText.text = 'Score: $score';
  }

  void brickDestroyed() {
    _brickCount--;
    if (_brickCount <= 0) {
      ball.stop();
      overlays.add('Win');
    }
  }

  void ballLost() {
    overlays.add('GameOver');
  }

  void restart() {
    overlays.remove('GameOver');
    overlays.remove('Win');
    score = 0;
    _started = false;
    scoreText.text = 'Score: 0';

    // Remove dynamic components
    children.whereType<_Brick>().toList().forEach((b) => b.removeFromParent());
    children
        .whereType<_BrickParticle>()
        .toList()
        .forEach((p) => p.removeFromParent());
    ball.removeFromParent();

    // Re-create
    ball = _Ball(
      position: Vector2(size.x / 2, size.y - 80),
      gameRef: this,
    );
    add(ball);
    _createBricks();
    paddle.position = Vector2(size.x / 2, size.y - 60);
    overlays.add('Tap');
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    paddle.move(info.delta.global.x);
    if (!_started) {
      ball.position.x = paddle.position.x;
    }
  }
}

class _Paddle extends RectangleComponent {
  final Vector2 gameSize;
  static const double paddleWidth = 100;
  static const double paddleHeight = 14;

  _Paddle({required this.gameSize, required super.position})
      : super(
          size: Vector2(paddleWidth, paddleHeight),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    paint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF6C63FF), Color(0xFF4ECDC4)],
      ).createShader(Rect.fromLTWH(0, 0, paddleWidth, paddleHeight));

    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    // Glow
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(-4, -4, size.x + 8, size.y + 8),
        const Radius.circular(10),
      ),
      Paint()
        ..color = const Color(0xFF6C63FF).withValues(alpha: 0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    // Paddle body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        size.toRect(),
        const Radius.circular(7),
      ),
      paint,
    );
  }

  void move(double dx) {
    position.x = (position.x + dx).clamp(
      paddleWidth / 2 + 4,
      gameSize.x - paddleWidth / 2 - 4,
    );
  }
}

class _Ball extends CircleComponent with CollisionCallbacks {
  static const double ballRadius = 8;
  static const double ballSpeed = 400;
  Vector2 velocity = Vector2.zero();
  final BrickBreakerFlameGame gameRef;
  bool _active = false;

  _Ball({required super.position, required this.gameRef})
      : super(radius: ballRadius, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    paint = Paint()..color = Colors.white;
    add(CircleHitbox());
  }

  void launch() {
    _active = true;
    final angle = -pi / 2 + (Random().nextDouble() - 0.5) * pi / 3;
    velocity = Vector2(cos(angle), sin(angle)) * ballSpeed;
  }

  void stop() {
    _active = false;
    velocity = Vector2.zero();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!_active) return;

    position += velocity * dt;

    // Ball fell below screen
    if (position.y > gameRef.size.y + ballRadius * 2) {
      _active = false;
      gameRef.ballLost();
    }
  }

  @override
  void render(Canvas canvas) {
    // Glow
    canvas.drawCircle(
      Offset.zero,
      ballRadius * 2,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    super.render(canvas);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (!_active) return;

    if (other is _Paddle) {
      // Bounce angle depends on where ball hits paddle
      final paddleCenter = other.position.x;
      final hitPos = (position.x - paddleCenter) / (_Paddle.paddleWidth / 2);
      final angle = -pi / 2 + hitPos * pi / 3;
      velocity = Vector2(cos(angle), sin(angle)) * ballSpeed;
    } else if (other is _Wall) {
      final mid = intersectionPoints.reduce((a, b) => a + b) /
          intersectionPoints.length.toDouble();

      // Determine which wall was hit
      if (mid.y <= 8) {
        // Top wall
        velocity.y = velocity.y.abs();
      } else if (mid.x <= 8) {
        // Left wall
        velocity.x = velocity.x.abs();
      } else {
        // Right wall
        velocity.x = -velocity.x.abs();
      }
    } else if (other is _Brick) {
      // Reflect based on intersection
      final brickCenter = other.position + other.size / 2;
      final diff = position - brickCenter;

      if (diff.x.abs() / other.size.x > diff.y.abs() / other.size.y) {
        velocity.x = -velocity.x;
      } else {
        velocity.y = -velocity.y;
      }

      other.hit();
    }
  }
}

class _Wall extends RectangleComponent {
  _Wall({required super.position, required Vector2 wallSize})
      : super(size: wallSize);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    paint = Paint()..color = Colors.transparent;
    add(RectangleHitbox());
  }
}

class _Brick extends RectangleComponent {
  final Color color;
  final int points;
  final BrickBreakerFlameGame gameRef;

  _Brick({
    required super.position,
    required Vector2 brickSize,
    required this.color,
    required this.points,
    required this.gameRef,
  }) : super(size: brickSize);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    paint = Paint()..color = color;
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    // Glow
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(-2, -2, size.x + 4, size.y + 4),
        const Radius.circular(6),
      ),
      Paint()
        ..color = color.withValues(alpha: 0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    // Body
    canvas.drawRRect(
      RRect.fromRectAndRadius(size.toRect(), const Radius.circular(4)),
      paint,
    );
    // Highlight
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(2, 2, size.x - 4, size.y / 3),
        const Radius.circular(4),
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.15),
    );
  }

  void hit() {
    gameRef.addScore(points);
    gameRef.brickDestroyed();

    // Spawn particles
    final rng = Random();
    for (int i = 0; i < 6; i++) {
      gameRef.add(_BrickParticle(
        position: position + size / 2,
        velocity: Vector2(
          (rng.nextDouble() - 0.5) * 200,
          (rng.nextDouble() - 0.5) * 200,
        ),
        color: color,
      ));
    }

    removeFromParent();
  }
}

class _BrickParticle extends CircleComponent {
  final Vector2 velocity;
  double life = 0.6;

  _BrickParticle({
    required super.position,
    required this.velocity,
    required Color color,
  }) : super(
          radius: 3,
          paint: Paint()..color = color,
          anchor: Anchor.center,
        );

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
    velocity.y += 400 * dt; // gravity
    life -= dt;
    paint.color = paint.color.withValues(alpha: (life / 0.6).clamp(0, 1));
    if (life <= 0) removeFromParent();
  }
}
