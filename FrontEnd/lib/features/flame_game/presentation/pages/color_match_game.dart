import 'dart:async';
import 'dart:math';

import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:flutter/material.dart';

import '../../../../navigation/custom_router/custom_route.dart';

class ColorMatchPage extends StatefulWidget {
  const ColorMatchPage({super.key});

  @override
  State<ColorMatchPage> createState() => _ColorMatchPageState();
}

class _ColorMatchPageState extends State<ColorMatchPage>
    with TickerProviderStateMixin {
  static const List<Color> _allColors = [
    Color(0xFF6C63FF),
    Color(0xFFFF6B6B),
    Color(0xFF4ECDC4),
    Color(0xFFFFE66D),
    Color(0xFF95E1D3),
    Color(0xFFF38181),
    Color(0xFFAA96DA),
    Color(0xFFFCBF49),
  ];

  late List<Color> _cards;
  late List<bool> _revealed;
  late List<bool> _matched;
  int? _firstIndex;
  int? _secondIndex;
  int _moves = 0;
  int _matchedPairs = 0;
  int _totalPairs = 8;
  bool _isChecking = false;
  Timer? _timer;
  int _seconds = 0;
  int _bestTime = 0;

  late List<AnimationController> _flipControllers;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    final colors = List<Color>.from(_allColors.sublist(0, _totalPairs));
    _cards = [...colors, ...colors]..shuffle(Random());
    _revealed = List.filled(_cards.length, false);
    _matched = List.filled(_cards.length, false);
    _firstIndex = null;
    _secondIndex = null;
    _moves = 0;
    _matchedPairs = 0;
    _isChecking = false;
    _seconds = 0;
    _timer?.cancel();

    _flipControllers = List.generate(
      _cards.length,
      (_) => AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _flipControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _seconds++);
    });
  }

  void _onCardTap(int index) {
    if (_isChecking || _revealed[index] || _matched[index]) return;

    if (_moves == 0 && _firstIndex == null) {
      _startTimer();
    }

    setState(() {
      _revealed[index] = true;
      _flipControllers[index].forward();

      if (_firstIndex == null) {
        _firstIndex = index;
      } else {
        _secondIndex = index;
        _moves++;
        _isChecking = true;

        if (_cards[_firstIndex!] == _cards[_secondIndex!]) {
          _matched[_firstIndex!] = true;
          _matched[_secondIndex!] = true;
          _matchedPairs++;
          _firstIndex = null;
          _secondIndex = null;
          _isChecking = false;

          if (_matchedPairs == _totalPairs) {
            _timer?.cancel();
            if (_bestTime == 0 || _seconds < _bestTime) {
              _bestTime = _seconds;
            }
          }
        } else {
          Future.delayed(const Duration(milliseconds: 800), () {
            if (!mounted) return;
            setState(() {
              _revealed[_firstIndex!] = false;
              _revealed[_secondIndex!] = false;
              _flipControllers[_firstIndex!].reverse();
              _flipControllers[_secondIndex!].reverse();
              _firstIndex = null;
              _secondIndex = null;
              _isChecking = false;
            });
          });
        }
      }
    });
  }

  void _resetGame() {
    for (final c in _flipControllers) {
      c.dispose();
    }
    setState(() {
      _initGame();
    });
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isComplete = _matchedPairs == _totalPairs;

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
          'Memory Match',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            16.ph,
            _buildStatsBar(),
            16.ph,
            if (isComplete) _buildWinBanner(),
            Expanded(child: _buildGrid()),
            _buildResetButton(),
            16.ph,
          ],
        ),
      ),
    );
  }

  Widget _buildStatsBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _buildStatChip(Icons.touch_app, '$_moves', 'Moves'),
          12.pw,
          _buildStatChip(Icons.timer, _formatTime(_seconds), 'Time'),
          12.pw,
          _buildStatChip(
              Icons.auto_awesome, '$_matchedPairs/$_totalPairs', 'Matched'),
          if (_bestTime > 0) ...[
            12.pw,
            _buildStatChip(Icons.emoji_events, _formatTime(_bestTime), 'Best'),
          ],
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: const Color(0xFF6C63FF).withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF6C63FF), size: 16),
            4.ph,
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWinBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF4ECDC4)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🎉', style: TextStyle(fontSize: 24)),
          12.pw,
          Text(
            'Completed in $_moves moves!',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: _cards.length,
            itemBuilder: (context, index) => _buildCard(index),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(int index) {
    final isRevealed = _revealed[index] || _matched[index];

    return GestureDetector(
      onTap: () => _onCardTap(index),
      child: AnimatedBuilder(
        animation: _flipControllers[index],
        builder: (context, child) {
          final angle = _flipControllers[index].value * pi;
          final isFront = angle <= pi / 2;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: isFront
                ? _buildCardBack(index)
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(pi),
                    child: _buildCardFront(index),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildCardBack(int index) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A2A4A), Color(0xFF1A1A2E)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3A3A5A)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.question_mark_rounded,
          color: Colors.white.withValues(alpha: 0.3),
          size: 28,
        ),
      ),
    );
  }

  Widget _buildCardFront(int index) {
    final color = _cards[index];
    final isMatched = _matched[index];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color,
            color.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isMatched ? Colors.white.withValues(alpha: 0.6) : color,
          width: isMatched ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: isMatched
            ? const Icon(Icons.check_circle, color: Colors.white, size: 32)
            : null,
      ),
    );
  }

  Widget _buildResetButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: _resetGame,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF4ECDC4)],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C63FF).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.refresh, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'New Game',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A widget that builds using an animation, similar to AnimatedBuilder.
class AnimatedBuilder extends StatelessWidget {
  final Animation<double> animation;
  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;

  const AnimatedBuilder({
    super.key,
    required this.animation,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder_(
      listenable: animation,
      builder: builder,
      child: child,
    );
  }
}

class AnimatedBuilder_ extends AnimatedWidget {
  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;

  const AnimatedBuilder_({
    super.key,
    required super.listenable,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return builder(context, child);
  }
}
