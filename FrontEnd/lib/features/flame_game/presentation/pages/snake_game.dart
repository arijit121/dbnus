import 'dart:async';
import 'dart:math';

import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:flutter/material.dart';

import '../../../../navigation/custom_router/custom_route.dart';

enum Direction { up, down, left, right }

class SnakeGamePage extends StatefulWidget {
  const SnakeGamePage({super.key});

  @override
  State<SnakeGamePage> createState() => _SnakeGamePageState();
}

class _SnakeGamePageState extends State<SnakeGamePage> {
  static const int gridSize = 20;
  static const Duration tickDuration = Duration(milliseconds: 180);

  List<Point<int>> snake = [];
  Point<int> food = const Point(10, 10);
  Direction direction = Direction.right;
  Direction nextDirection = Direction.right;
  bool isPlaying = false;
  bool gameOver = false;
  int score = 0;
  int highScore = 0;
  Timer? _gameTimer;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }

  void _initGame() {
    snake = [
      const Point(5, 10),
      const Point(4, 10),
      const Point(3, 10),
    ];
    direction = Direction.right;
    nextDirection = Direction.right;
    score = 0;
    gameOver = false;
    _spawnFood();
  }

  void _spawnFood() {
    final random = Random();
    Point<int> newFood;
    do {
      newFood = Point(random.nextInt(gridSize), random.nextInt(gridSize));
    } while (snake.contains(newFood));
    food = newFood;
  }

  void _startGame() {
    if (gameOver) _initGame();
    setState(() => isPlaying = true);
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(tickDuration, (_) => _tick());
  }

  void _pauseGame() {
    setState(() => isPlaying = false);
    _gameTimer?.cancel();
  }

  void _tick() {
    if (!mounted) return;
    setState(() {
      direction = nextDirection;
      final head = snake.first;
      Point<int> newHead;
      switch (direction) {
        case Direction.up:
          newHead = Point(head.x, head.y - 1);
        case Direction.down:
          newHead = Point(head.x, head.y + 1);
        case Direction.left:
          newHead = Point(head.x - 1, head.y);
        case Direction.right:
          newHead = Point(head.x + 1, head.y);
      }

      if (newHead.x < 0 ||
          newHead.x >= gridSize ||
          newHead.y < 0 ||
          newHead.y >= gridSize ||
          snake.contains(newHead)) {
        _endGame();
        return;
      }

      snake.insert(0, newHead);
      if (newHead == food) {
        score++;
        _spawnFood();
      } else {
        snake.removeLast();
      }
    });
  }

  void _endGame() {
    isPlaying = false;
    gameOver = true;
    _gameTimer?.cancel();
    if (score > highScore) highScore = score;
  }

  void _setDirection(Direction newDir) {
    if ((direction == Direction.up && newDir == Direction.down) ||
        (direction == Direction.down && newDir == Direction.up) ||
        (direction == Direction.left && newDir == Direction.right) ||
        (direction == Direction.right && newDir == Direction.left)) {
      return;
    }
    nextDirection = newDir;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            _gameTimer?.cancel();
            CustomRoute.back();
          },
        ),
        title: const Text('Snake Game',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20)),
      ),
      body: SafeArea(
        child: GestureDetector(
          onVerticalDragUpdate: (d) {
            if (d.delta.dy > 2) _setDirection(Direction.down);
            if (d.delta.dy < -2) _setDirection(Direction.up);
          },
          onHorizontalDragUpdate: (d) {
            if (d.delta.dx > 2) _setDirection(Direction.right);
            if (d.delta.dx < -2) _setDirection(Direction.left);
          },
          child: Column(
            children: [
              16.ph,
              _buildScoreBar(),
              16.ph,
              Expanded(child: _buildGameBoard()),
              if (gameOver) _buildGameOverBanner(),
              _buildControls(),
              16.ph,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(children: [
        _buildStat(
            Icons.restaurant, '$score', 'Score', const Color(0xFF4ECDC4)),
        12.pw,
        _buildStat(
            Icons.emoji_events, '$highScore', 'Best', const Color(0xFFFFE66D)),
        12.pw,
        _buildStat(Icons.straighten, '${snake.length}', 'Length',
            const Color(0xFF6C63FF)),
      ]),
    );
  }

  Widget _buildStat(IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(children: [
          Icon(icon, color: color, size: 18),
          4.ph,
          Text(value,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w800, fontSize: 20)),
          Text(label,
              style:
                  TextStyle(color: color.withValues(alpha: 0.7), fontSize: 11)),
        ]),
      ),
    );
  }

  Widget _buildGameBoard() {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: const Color(0xFF4ECDC4).withValues(alpha: 0.3),
                width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: CustomPaint(
              painter:
                  _SnakePainter(snake: snake, food: food, gridSize: gridSize),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameOverBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFEE5A24)]),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text('💀', style: TextStyle(fontSize: 22)),
        12.pw,
        Text('Game Over! Score: $score',
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16)),
      ]),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(children: [
        8.ph,
        SizedBox(
          width: double.infinity,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: isPlaying ? _pauseGame : _startGame,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isPlaying || gameOver
                        ? [const Color(0xFFFF6B6B), const Color(0xFFEE5A24)]
                        : [const Color(0xFF4ECDC4), const Color(0xFF44B09E)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(
                      gameOver
                          ? Icons.refresh
                          : isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                      color: Colors.white,
                      size: 20),
                  8.pw,
                  Text(
                      gameOver
                          ? 'Play Again'
                          : isPlaying
                              ? 'Pause'
                              : 'Start',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15)),
                ]),
              ),
            ),
          ),
        ),
        12.ph,
        _buildDPad(),
      ]),
    );
  }

  Widget _buildDPad() {
    return SizedBox(
      height: 130,
      child: Column(children: [
        _dBtn(Icons.keyboard_arrow_up, Direction.up),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _dBtn(Icons.keyboard_arrow_left, Direction.left),
          const SizedBox(width: 48, height: 42),
          _dBtn(Icons.keyboard_arrow_right, Direction.right),
        ]),
        _dBtn(Icons.keyboard_arrow_down, Direction.down),
      ]),
    );
  }

  Widget _dBtn(IconData icon, Direction dir) {
    return GestureDetector(
      onTap: () => _setDirection(dir),
      child: Container(
        width: 48,
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A4A),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF3A3A5A)),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}

class _SnakePainter extends CustomPainter {
  final List<Point<int>> snake;
  final Point<int> food;
  final int gridSize;

  _SnakePainter(
      {required this.snake, required this.food, required this.gridSize});

  @override
  void paint(Canvas canvas, Size size) {
    final cellSize = size.width / gridSize;

    // Food
    final foodRect = Rect.fromLTWH(food.x * cellSize + 2, food.y * cellSize + 2,
        cellSize - 4, cellSize - 4);
    canvas.drawRRect(
        RRect.fromRectAndRadius(foodRect, const Radius.circular(4)),
        Paint()..color = const Color(0xFFFF6B6B));

    // Snake
    for (int i = 0; i < snake.length; i++) {
      final s = snake[i];
      final isHead = i == 0;
      final progress = 1.0 - (i / snake.length) * 0.5;
      final color = isHead
          ? const Color(0xFF4ECDC4)
          : Color.lerp(
              const Color(0xFF4ECDC4), const Color(0xFF1A5C54), 1 - progress)!;
      final rect = Rect.fromLTWH(
          s.x * cellSize + 1, s.y * cellSize + 1, cellSize - 2, cellSize - 2);
      canvas.drawRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(isHead ? 5 : 3)),
          Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant _SnakePainter oldDelegate) => true;
}
