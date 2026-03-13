import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

class RouteInfoBar extends StatefulWidget {
  final double distanceKm;
  final double durationMinutes;
  final VoidCallback onClose;
  final VoidCallback? onStartNavigation;
  final String? routeSummary;

  const RouteInfoBar({
    super.key,
    required this.distanceKm,
    required this.durationMinutes,
    required this.onClose,
    this.onStartNavigation,
    this.routeSummary,
  });

  @override
  State<RouteInfoBar> createState() => _RouteInfoBarState();
}

class _RouteInfoBarState extends State<RouteInfoBar> {
  int _selectedMode = 0; // 0=Car, 1=Bike, 2=Walk

  String _formatDistance() {
    if (widget.distanceKm < 1) {
      return '${(widget.distanceKm * 1000).round()} m';
    }
    return '${widget.distanceKm.toStringAsFixed(1)} km';
  }

  String _formatDuration() {
    // Adjust duration based on transport mode
    double adjustedMin = widget.durationMinutes;
    if (_selectedMode == 1) {
      adjustedMin = widget.durationMinutes * 1.3; // Bike is ~1.3x car
    } else if (_selectedMode == 2) {
      adjustedMin = widget.durationMinutes * 4; // Walk is ~4x car
    }

    final totalMin = adjustedMin.round();
    if (totalMin < 60) return '$totalMin min';
    final hours = totalMin ~/ 60;
    final mins = totalMin % 60;
    return '${hours}h ${mins}m';
  }

  String _getETA() {
    double adjustedMin = widget.durationMinutes;
    if (_selectedMode == 1) adjustedMin *= 1.3;
    if (_selectedMode == 2) adjustedMin *= 4;

    final now = DateTime.now();
    final eta = now.add(Duration(minutes: adjustedMin.round()));
    final hour = eta.hour;
    final minute = eta.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'pm' : 'am';
    final h12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$h12:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final modes = [
      (FeatherIcons.truck, 'Car'),
      (FeatherIcons.zap, 'Bike'),
      (FeatherIcons.user, 'Walk'),
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Transport Mode Tabs ──────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Row(
              children: List.generate(modes.length, (index) {
                final isSelected = _selectedMode == index;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedMode = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: EdgeInsets.only(
                        right: index < modes.length - 1 ? 6 : 0,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF4285F4).withValues(alpha: 0.1)
                            : const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF4285F4).withValues(alpha: 0.4)
                              : const Color(0xFFE8EAED),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            modes[index].$1,
                            size: 14,
                            color: isSelected
                                ? const Color(0xFF4285F4)
                                : const Color(0xFF9AA0A6),
                          ),
                          4.pw,
                          CustomText(
                            modes[index].$2,
                            color: isSelected
                                ? const Color(0xFF4285F4)
                                : const Color(0xFF9AA0A6),
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            size: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          // ── Route Info ────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 8, 0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF34A853).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(FeatherIcons.navigation,
                      color: Color(0xFF34A853), size: 18),
                ),
                12.pw,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          CustomText(
                            _formatDuration(),
                            color: const Color(0xFF34A853),
                            fontWeight: FontWeight.w700,
                            size: 20,
                          ),
                          8.pw,
                          CustomText(
                            '(${_formatDistance()})',
                            color: const Color(0xFF5F6368),
                            size: 13,
                          ),
                        ],
                      ),
                      2.ph,
                      CustomText(
                        'ETA ${_getETA()}',
                        color: const Color(0xFF9AA0A6),
                        size: 12,
                      ),
                    ],
                  ),
                ),
                // Close button
                GestureDetector(
                  onTap: widget.onClose,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F3F4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(FeatherIcons.x,
                        size: 16, color: Color(0xFF5F6368)),
                  ),
                ),
              ],
            ),
          ),

          // ── Route Summary ─────────────────────────────────
          if (widget.routeSummary != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
              child: CustomText(
                widget.routeSummary!,
                color: const Color(0xFF5F6368),
                size: 12,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

          8.ph,

          // ── Action Buttons ────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Row(
              children: [
                // Start Navigation Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: widget.onStartNavigation,
                    icon: const Icon(FeatherIcons.navigation2, size: 18),
                    label: const Text('Start',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4285F4),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                8.pw,
                // Share button
                _ActionIcon(
                  icon: FeatherIcons.share2,
                  onTap: () {},
                ),
                6.pw,
                // Save button
                _ActionIcon(
                  icon: FeatherIcons.bookmark,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F3F4),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 18, color: const Color(0xFF5F6368)),
      ),
    );
  }
}
