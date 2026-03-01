import 'dart:async';
import 'dart:math';

import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:flutter/material.dart';

import '../../../../navigation/custom_router/custom_route.dart';

enum _GamePhase { waiting, ready, tooEarly, result }

class ReactionTimePage extends StatefulWidget {
  const ReactionTimePage({super.key});

  @override
  State<ReactionTimePage> createState() => _ReactionTimePageState();
}

class _ReactionTimePageState extends State<ReactionTimePage> {
  _GamePhase phase = _GamePhase.waiting;
  int reactionMs = 0;
  int bestMs = 0;
  int round = 0;
  List<int> results = [];
  late DateTime _startTime;
  Timer? _delayTimer;

  @override
  void dispose() {
    _delayTimer?.cancel();
    super.dispose();
  }

  void _onTap() {
    switch (phase) {
      case _GamePhase.waiting:
        _beginWait();
        break;
      case _GamePhase.ready:
        // Tapped too early
        _delayTimer?.cancel();
        setState(() => phase = _GamePhase.tooEarly);
        break;
      case _GamePhase.tooEarly:
        setState(() => phase = _GamePhase.waiting);
        break;
      case _GamePhase.result:
        if (_greenShown) {
          final ms = DateTime.now().difference(_startTime).inMilliseconds;
          setState(() {
            reactionMs = ms;
            round++;
            results.add(ms);
            if (bestMs == 0 || ms < bestMs) bestMs = ms;
            _greenShown = false;
            phase = _GamePhase.waiting;
          });
        }
        break;
    }
  }

  bool _greenShown = false;

  void _beginWait() {
    setState(() {
      phase = _GamePhase.ready;
      _greenShown = false;
    });
    final delay = Duration(milliseconds: 1500 + Random().nextInt(3500));
    _delayTimer = Timer(delay, () {
      if (!mounted) return;
      setState(() {
        _startTime = DateTime.now();
        _greenShown = true;
      });
    });
  }

  Color get _bgColor {
    if (phase == _GamePhase.tooEarly) return const Color(0xFFFF6B6B);
    if (_greenShown) return const Color(0xFF4ECDC4);
    if (phase == _GamePhase.ready) return const Color(0xFFEE5A24);
    return const Color(0xFF0F0E17);
  }

  String get _message {
    if (phase == _GamePhase.tooEarly) return 'Too Early! 😅\nTap to try again';
    if (_greenShown) return 'TAP NOW! ⚡';
    if (phase == _GamePhase.ready) return 'Wait for green...';
    return 'Tap to Start';
  }

  int get _average {
    if (results.isEmpty) return 0;
    return results.reduce((a, b) => a + b) ~/ results.length;
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
            _delayTimer?.cancel();
            CustomRoute.back();
          },
        ),
        title: const Text('Reaction Time',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20)),
        actions: [
          if (results.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () {
                _delayTimer?.cancel();
                setState(() {
                  results.clear();
                  round = 0;
                  bestMs = 0;
                  reactionMs = 0;
                  phase = _GamePhase.waiting;
                  _greenShown = false;
                });
              },
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            16.ph,
            if (results.isNotEmpty) _buildStats(),
            Expanded(child: _buildTapArea()),
            if (results.isNotEmpty) _buildHistory(),
            16.ph,
          ],
        ),
      ),
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(children: [
        _buildStatChip(
            Icons.speed, '${reactionMs}ms', 'Last', const Color(0xFF6C63FF)),
        12.pw,
        _buildStatChip(
            Icons.emoji_events, '${bestMs}ms', 'Best', const Color(0xFF4ECDC4)),
        12.pw,
        _buildStatChip(
            Icons.analytics, '${_average}ms', 'Avg', const Color(0xFFFFE66D)),
        12.pw,
        _buildStatChip(
            Icons.repeat, '$round', 'Rounds', const Color(0xFFFF6B6B)),
      ]),
    );
  }

  Widget _buildStatChip(
      IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(children: [
          Icon(icon, color: color, size: 14),
          2.ph,
          Text(value,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w700, fontSize: 13)),
          Text(label,
              style:
                  TextStyle(color: color.withValues(alpha: 0.6), fontSize: 9)),
        ]),
      ),
    );
  }

  Widget _buildTapArea() {
    return GestureDetector(
      onTap: _onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: _bgColor.withValues(alpha: 0.4),
              blurRadius: 30,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Text(
            _message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color:
                  phase == _GamePhase.waiting ? Colors.white70 : Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: _greenShown ? 32 : 22,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistory() {
    final last5 =
        results.length > 5 ? results.sublist(results.length - 5) : results;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: last5.asMap().entries.map((e) {
          final ms = e.value;
          final color = ms < 250
              ? const Color(0xFF4ECDC4)
              : ms < 400
                  ? const Color(0xFFFFE66D)
                  : const Color(0xFFFF6B6B);
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Text('${ms}ms',
                style: TextStyle(
                    color: color, fontWeight: FontWeight.w600, fontSize: 12)),
          );
        }).toList(),
      ),
    );
  }
}
