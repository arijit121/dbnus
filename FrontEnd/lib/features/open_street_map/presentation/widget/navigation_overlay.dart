import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

class NavigationOverlay extends StatelessWidget {
  final double remainingDistanceKm;
  final double remainingDurationMin;
  final double speedKmh;
  final int currentStep;
  final int totalSteps;
  final VoidCallback onStop;

  const NavigationOverlay({
    super.key,
    required this.remainingDistanceKm,
    required this.remainingDurationMin,
    required this.speedKmh,
    required this.currentStep,
    required this.totalSteps,
    required this.onStop,
  });

  String _formatDistance(double km) {
    if (km < 1) return '${(km * 1000).round()} m';
    return '${km.toStringAsFixed(1)} km';
  }

  String _formatDuration(double min) {
    final totalMin = min.round();
    if (totalMin < 1) return '<1 min';
    if (totalMin < 60) return '$totalMin min';
    final hours = totalMin ~/ 60;
    final mins = totalMin % 60;
    return '${hours}h ${mins}m';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Top direction banner
        Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A73E8),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1A73E8).withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(FeatherIcons.navigation2,
                    color: Colors.white, size: 22),
              ),
              16.pw,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      'Navigating',
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      size: 18,
                    ),
                    4.ph,
                    CustomText(
                      '${_formatDistance(remainingDistanceKm)} remaining',
                      color: Colors.white70,
                      size: 13,
                    ),
                  ],
                ),
              ),
              CustomText(
                _formatDuration(remainingDurationMin),
                color: Colors.white,
                fontWeight: FontWeight.w700,
                size: 20,
              ),
            ],
          ),
        ),

        // Bottom info bar
        Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Speed
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F3F4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CustomText(
                  '${speedKmh.round()} km/h',
                  color: const Color(0xFF202124),
                  fontWeight: FontWeight.w600,
                  size: 13,
                ),
              ),
              12.pw,
              // Progress
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: totalSteps > 0 ? currentStep / totalSteps : 0,
                        backgroundColor: const Color(0xFFE8EAED),
                        color: const Color(0xFF4285F4),
                        minHeight: 6,
                      ),
                    ),
                    4.ph,
                    CustomText(
                      'Step $currentStep of $totalSteps',
                      color: const Color(0xFF9AA0A6),
                      size: 11,
                    ),
                  ],
                ),
              ),
              12.pw,
              // Stop button
              GestureDetector(
                onTap: onStop,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEA4335),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(FeatherIcons.square, size: 14, color: Colors.white),
                      SizedBox(width: 6),
                      CustomText(
                        'Stop',
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        size: 13,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
