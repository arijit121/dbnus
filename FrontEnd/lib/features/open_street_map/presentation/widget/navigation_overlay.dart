import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:dbnus/shared/constants/assects_const.dart';
import 'package:dbnus/shared/ui/atoms/images/custom_image.dart';
import 'package:material_ui/material_ui.dart';

class NavigationOverlay extends StatelessWidget {
  final double remainingDistanceKm;
  final double remainingDurationMin;
  final double speedKmh;
  final int currentStep;
  final int totalSteps;
  final VoidCallback onStop;
  final String? currentInstruction;
  final String? nextInstruction;
  final String? maneuverType;
  final String? maneuverModifier;
  final double? distanceToNextStepMeters;

  const NavigationOverlay({
    super.key,
    required this.remainingDistanceKm,
    required this.remainingDurationMin,
    required this.speedKmh,
    required this.currentStep,
    required this.totalSteps,
    required this.onStop,
    this.currentInstruction,
    this.nextInstruction,
    this.maneuverType,
    this.maneuverModifier,
    this.distanceToNextStepMeters,
  });

  String _formatDistance(double km) {
    if (km < 1) return '${(km * 1000).round()} m';
    return '${km.toStringAsFixed(1)} km';
  }

  String _formatStepDistance(double meters) {
    if (meters < 1000) return '${meters.round()} m';
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }

  String _formatDuration(double min) {
    final totalMin = min.round();
    if (totalMin < 1) return '<1 min';
    if (totalMin < 60) return '$totalMin min';
    final hours = totalMin ~/ 60;
    final mins = totalMin % 60;
    return '${hours}h ${mins}m';
  }

  String _getETA(double remainingMin) {
    final now = DateTime.now();
    final eta = now.add(Duration(minutes: remainingMin.round()));
    final hour = eta.hour;
    final minute = eta.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'pm' : 'am';
    final h12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$h12:$minute $period';
  }

  String _getManeuverIcon() {
    switch (maneuverType) {
      case 'turn':
        switch (maneuverModifier) {
          case 'left':
            return AssetsConst.featherCornerUpLeft;
          case 'right':
            return AssetsConst.featherCornerUpRight;
          case 'slight left':
            return AssetsConst.featherCornerUpLeft;
          case 'slight right':
            return AssetsConst.featherCornerUpRight;
          case 'sharp left':
            return AssetsConst.featherCornerDownLeft;
          case 'sharp right':
            return AssetsConst.featherCornerDownRight;
          case 'uturn':
            return AssetsConst.featherRotateCcw;
          default:
            return AssetsConst.featherArrowUp;
        }
      case 'fork':
        return maneuverModifier == 'left'
            ? AssetsConst.featherGitBranch
            : AssetsConst.featherGitBranch;
      case 'roundabout':
      case 'rotary':
        return AssetsConst.featherRefreshCw;
      case 'arrive':
        return AssetsConst.featherFlag;
      case 'depart':
        return AssetsConst.featherNavigation2;
      case 'merge':
        return AssetsConst.featherGitMerge;
      case 'end of road':
        return maneuverModifier == 'left'
            ? AssetsConst.featherCornerUpLeft
            : AssetsConst.featherCornerUpRight;
      default:
        return AssetsConst.featherArrowUp;
    }
  }

  String _getNextManeuverIcon(String? instruction) {
    if (instruction == null) return AssetsConst.featherArrowUp;
    final lower = instruction.toLowerCase();
    if (lower.contains('left')) return AssetsConst.featherCornerUpLeft;
    if (lower.contains('right')) return AssetsConst.featherCornerUpRight;
    if (lower.contains('roundabout')) return AssetsConst.featherRefreshCw;
    if (lower.contains('arrive')) return AssetsConst.featherFlag;
    return AssetsConst.featherArrowUp;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Top Direction Banner ──────────────────────────
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            decoration: BoxDecoration(
              color: const Color(0xFF1B5E20),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Main direction row
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Maneuver icon
                      CustomSvgAssetImageView(
                        path: _getManeuverIcon(),
                        color: Colors.white,
                        height: 36, width: 36,
                      ),
                      16.pw,
                      // Instruction text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (distanceToNextStepMeters != null)
                              CustomText(
                                _formatStepDistance(
                                    distanceToNextStepMeters!),
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                size: 22,
                              ),
                            if (currentInstruction != null) ...[
                              4.ph,
                              CustomText(
                                currentInstruction!,
                                color: Colors.white.withValues(alpha: 0.9),
                                fontWeight: FontWeight.w500,
                                size: 14,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // "Then" preview for next step
                if (nextInstruction != null)
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.2),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      children: [
                        const CustomText(
                          'Then',
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                          size: 12,
                        ),
                        8.pw,
                        CustomSvgAssetImageView(
                          path: _getNextManeuverIcon(nextInstruction),
                          color: Colors.white70,
                          height: 16, width: 16,
                        ),
                        8.pw,
                        Expanded(
                          child: CustomText(
                            nextInstruction!,
                            color: Colors.white70,
                            size: 12,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          8.ph,

          // ── Bottom Info Bar ───────────────────────────────
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // ETA & distance info
                Expanded(
                  child: Row(
                    children: [
                      // ETA badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF34A853),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: CustomText(
                          _formatDuration(remainingDurationMin),
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          size: 14,
                        ),
                      ),
                      10.pw,
                      // Distance + ETA clock
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomText(
                            _formatDistance(remainingDistanceKm),
                            color: Colors.white70,
                            size: 12,
                          ),
                          CustomText(
                            _getETA(remainingDurationMin),
                            color: Colors.white54,
                            size: 11,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Speed indicator
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomText(
                    '${speedKmh.round()}\nkm/h',
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                    size: 11,
                    textAlign: TextAlign.center,
                  ),
                ),
                12.pw,
                // Stop button
                GestureDetector(
                  onTap: onStop,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEA4335),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomSvgAssetImageView(path: AssetsConst.featherX, height: 16, width: 16, color: Colors.white),
                        SizedBox(width: 4),
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
      ),
    );
  }
}
