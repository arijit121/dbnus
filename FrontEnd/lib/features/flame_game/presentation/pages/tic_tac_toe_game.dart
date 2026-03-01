import 'dart:math';

import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:flutter/material.dart';

import '../../../../navigation/custom_router/custom_route.dart';

class TicTacToePage extends StatefulWidget {
  const TicTacToePage({super.key});

  @override
  State<TicTacToePage> createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage>
    with TickerProviderStateMixin {
  List<String> board = List.filled(9, '');
  bool isXTurn = true;
  String winner = '';
  int scoreX = 0;
  int scoreO = 0;
  int draws = 0;
  bool playWithAI = false;
  List<int> winningLine = [];

  late List<AnimationController> _cellControllers;
  late List<Animation<double>> _cellAnimations;

  @override
  void initState() {
    super.initState();
    _cellControllers = List.generate(
      9,
      (_) => AnimationController(
        duration: const Duration(milliseconds: 350),
        vsync: this,
      ),
    );
    _cellAnimations = _cellControllers.map((c) {
      return CurvedAnimation(parent: c, curve: Curves.elasticOut);
    }).toList();
  }

  @override
  void dispose() {
    for (final c in _cellControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _handleTap(int index) {
    if (board[index].isNotEmpty || winner.isNotEmpty) return;

    setState(() {
      board[index] = isXTurn ? 'X' : 'O';
      _cellControllers[index].forward(from: 0);
      _checkWinner();
      if (winner.isEmpty) {
        isXTurn = !isXTurn;
        if (playWithAI && !isXTurn && winner.isEmpty) {
          _aiMove();
        }
      }
    });
  }

  void _aiMove() {
    final empty = <int>[];
    for (int i = 0; i < 9; i++) {
      if (board[i].isEmpty) empty.add(i);
    }
    if (empty.isEmpty) return;

    // Simple AI: try to win, then block, then random
    int? move = _findBestMove('O') ?? _findBestMove('X');
    move ??= empty[Random().nextInt(empty.length)];

    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      _handleTap(move!);
    });
  }

  int? _findBestMove(String player) {
    const lines = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];
    for (final line in lines) {
      final values = line.map((i) => board[i]).toList();
      if (values.where((v) => v == player).length == 2 && values.contains('')) {
        return line[values.indexOf('')];
      }
    }
    return null;
  }

  void _checkWinner() {
    const lines = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (final line in lines) {
      if (board[line[0]].isNotEmpty &&
          board[line[0]] == board[line[1]] &&
          board[line[1]] == board[line[2]]) {
        winner = board[line[0]];
        winningLine = line;
        if (winner == 'X') {
          scoreX++;
        } else {
          scoreO++;
        }
        return;
      }
    }

    if (!board.contains('')) {
      winner = 'Draw';
      draws++;
    }
  }

  void _resetBoard() {
    setState(() {
      board = List.filled(9, '');
      winner = '';
      isXTurn = true;
      winningLine = [];
      for (final c in _cellControllers) {
        c.reset();
      }
    });
  }

  void _resetScores() {
    setState(() {
      scoreX = 0;
      scoreO = 0;
      draws = 0;
      _resetBoard();
    });
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
          onPressed: () => CustomRoute.back(),
        ),
        title: const Text(
          'Tic Tac Toe',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              playWithAI ? Icons.smart_toy : Icons.people,
              color: Colors.white,
            ),
            tooltip: playWithAI ? 'Playing vs AI' : 'Playing vs Human',
            onPressed: () {
              setState(() {
                playWithAI = !playWithAI;
                _resetBoard();
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            16.ph,
            // Score Board
            _buildScoreBoard(),
            24.ph,
            // Turn Indicator
            _buildTurnIndicator(),
            24.ph,
            // Game Board
            Expanded(child: _buildBoard()),
            // Reset Buttons
            _buildControls(),
            16.ph,
          ],
        ),
      ),
    );
  }

  Widget _buildScoreBoard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _buildScoreCard('X', scoreX, const Color(0xFF6C63FF)),
          12.pw,
          _buildScoreCard('Draw', draws, const Color(0xFF4A4A6A)),
          12.pw,
          _buildScoreCard('O', scoreO, const Color(0xFFFF6B6B)),
        ],
      ),
    );
  }

  Widget _buildScoreCard(String label, int score, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.3),
              color.withValues(alpha: 0.1)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            4.ph,
            Text(
              '$score',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTurnIndicator() {
    String message;
    Color color;
    if (winner == 'Draw') {
      message = "It's a Draw!";
      color = const Color(0xFF4A4A6A);
    } else if (winner.isNotEmpty) {
      message = '$winner Wins! 🎉';
      color = winner == 'X' ? const Color(0xFF6C63FF) : const Color(0xFFFF6B6B);
    } else {
      message = playWithAI && !isXTurn
          ? 'AI is thinking...'
          : "${isXTurn ? 'X' : 'O'}'s Turn";
      color = isXTurn ? const Color(0xFF6C63FF) : const Color(0xFFFF6B6B);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildBoard() {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF1A1A2E),
                const Color(0xFF16213E),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6C63FF).withValues(alpha: 0.15),
                blurRadius: 30,
                spreadRadius: 2,
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: 9,
            itemBuilder: (context, index) => _buildCell(index),
          ),
        ),
      ),
    );
  }

  Widget _buildCell(int index) {
    final isWinCell = winningLine.contains(index);
    final value = board[index];

    Color cellColor;
    if (isWinCell) {
      cellColor = winner == 'X'
          ? const Color(0xFF6C63FF).withValues(alpha: 0.4)
          : const Color(0xFFFF6B6B).withValues(alpha: 0.4);
    } else {
      cellColor = const Color(0xFF2A2A4A);
    }

    return GestureDetector(
      onTap: () => _handleTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: cellColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isWinCell
                ? (winner == 'X'
                    ? const Color(0xFF6C63FF)
                    : const Color(0xFFFF6B6B))
                : const Color(0xFF3A3A5A),
            width: isWinCell ? 2 : 1,
          ),
        ),
        child: Center(
          child: value.isEmpty
              ? null
              : ScaleTransition(
                  scale: _cellAnimations[index],
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      color: value == 'X'
                          ? const Color(0xFF6C63FF)
                          : const Color(0xFFFF6B6B),
                      shadows: [
                        Shadow(
                          color: (value == 'X'
                                  ? const Color(0xFF6C63FF)
                                  : const Color(0xFFFF6B6B))
                              .withValues(alpha: 0.5),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildControlButton(
              icon: Icons.refresh,
              label: 'New Game',
              gradient: [const Color(0xFF6C63FF), ColorConst.sidebarSelected],
              onTap: _resetBoard,
            ),
          ),
          12.pw,
          Expanded(
            child: _buildControlButton(
              icon: Icons.restart_alt,
              label: 'Reset Scores',
              gradient: [const Color(0xFFFF6B6B), const Color(0xFFEE5A24)],
              onTap: _resetScores,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradient),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: gradient.first.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              8.pw,
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
