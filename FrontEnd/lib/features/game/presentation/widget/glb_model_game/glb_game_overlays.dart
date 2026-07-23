import 'package:flutter/material.dart';
import '../../../../../shared/ui/atoms/buttons/custom_button.dart';
import '../../../../../shared/ui/atoms/text/custom_text.dart';

class GlbGameLoadingOverlay extends StatelessWidget {
  final String? initError;
  final VoidCallback onRetry;

  const GlbGameLoadingOverlay({
    super.key,
    required this.initError,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: const Color(0xFF060614),
        child: Center(
          child: initError != null
              ? Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline,
                          color: Color(0xFFFF0055), size: 48),
                      const SizedBox(height: 16),
                      CustomText('Engine Error: $initError',
                          color: Colors.white,
                          size: 14,
                          textAlign: TextAlign.center),
                      const SizedBox(height: 24),
                      CustomGOEButton(
                        onPressed: onRetry,
                        backGroundColor: const Color(0xFFFF0055),
                        child: const CustomText('Retry Engine',
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              : const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF00F0FF)),
                    ),
                    SizedBox(height: 16),
                    CustomText('Loading GLB Spaceship Engine...',
                        color: Color(0xFF8B8BA7),
                        size: 14,
                        fontWeight: FontWeight.bold),
                  ],
                ),
        ),
      ),
    );
  }
}

class GlbGameStartOverlay extends StatelessWidget {
  final bool isInitialized;
  final VoidCallback onStart;

  const GlbGameStartOverlay({
    super.key,
    required this.isInitialized,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.8),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(32),
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              color: const Color(0xEE060618),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0x6600f0ff), width: 2),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x3300f0ff),
                  blurRadius: 30,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CustomText('Spaceship GLB Arena',
                    color: Colors.white,
                    size: 28,
                    fontWeight: FontWeight.w900),
                const SizedBox(height: 8),
                const CustomText('3D GLB Flight Simulator',
                    color: Color(0xFF8B8BA7),
                    size: 14,
                    fontWeight: FontWeight.bold),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: Colors.white.withValues(alpha: 0.05)),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText('🚀 Fly GLB Spaceship in 3D',
                          color: Color(0xFFA4A4C1), size: 12),
                      SizedBox(height: 6),
                      CustomText('⚡ Shoot down space debris & asteroids',
                          color: Color(0xFFA4A4C1), size: 12),
                      SizedBox(height: 6),
                      CustomText('💎 Collect energy cores & repair shields',
                          color: Color(0xFFA4A4C1), size: 12),
                      SizedBox(height: 12),
                      CustomText('Flight Controls:',
                          color: Color(0xFF00F0FF),
                          size: 12,
                          fontWeight: FontWeight.bold),
                      SizedBox(height: 4),
                      CustomText(
                          '💻 PC: ARROW / WASD keys (Steer) \n    SPACEBAR (Fire Lasers)',
                          color: Color(0xFFA4A4C1),
                          size: 12),
                      SizedBox(height: 6),
                      CustomText(
                          '📱 Mobile: Drag left stick to steer\n    Tap right button to fire',
                          color: Color(0xFFA4A4C1),
                          size: 12),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                CustomGOEButton(
                  onPressed: onStart,
                  width: double.infinity,
                  height: 48,
                  backGroundColor: isInitialized
                      ? const Color(0xFF00F0FF)
                      : const Color(0xFF555566),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  borderRadius: BorderRadius.circular(14),
                  child: isInitialized
                      ? const CustomText('Launch Simulator',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          size: 16)
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            SizedBox(width: 10),
                            CustomText('Preparing Ship...',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                size: 14),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GlbGameOverOverlay extends StatelessWidget {
  final int score;
  final int highScore;
  final VoidCallback onRelaunch;

  const GlbGameOverOverlay({
    super.key,
    required this.score,
    required this.highScore,
    required this.onRelaunch,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.85),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(32),
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              color: const Color(0xEE060618),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0x66ff0055), width: 2),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33ff0055),
                  blurRadius: 30,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CustomText('Hull Integrity Critical',
                    color: Color(0xFFFF0055),
                    size: 26,
                    fontWeight: FontWeight.w900),
                const SizedBox(height: 8),
                const CustomText('Simulation Terminated',
                    color: Color(0xFF8B8BA7),
                    size: 14,
                    fontWeight: FontWeight.bold),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText('Simulation Score:',
                        color: Color(0xFFA4A4C1), size: 16),
                    CustomText('$score',
                        color: const Color(0xFFFF0055),
                        size: 18,
                        fontWeight: FontWeight.bold),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText('Best Score:',
                        color: Color(0xFFA4A4C1), size: 16),
                    CustomText('$highScore',
                        color: const Color(0xFF00F0FF),
                        size: 18,
                        fontWeight: FontWeight.bold),
                  ],
                ),
                const SizedBox(height: 28),
                CustomGOEButton(
                  onPressed: onRelaunch,
                  width: double.infinity,
                  height: 48,
                  backGroundColor: const Color(0xFFFF0055),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  borderRadius: BorderRadius.circular(14),
                  child: const CustomText('Relaunch Ship',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      size: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
