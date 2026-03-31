import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:intl/intl.dart';
import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:dbnus/core/localization/extension/localization_ext.dart';
import 'package:dbnus/flavors.dart';

class WelcomeHeader extends StatefulWidget {
  const WelcomeHeader({
    super.key,
    required this.counter,
  });

  final ValueNotifier<int> counter;

  @override
  State<WelcomeHeader> createState() => _WelcomeHeaderState();
}

class _WelcomeHeaderState extends State<WelcomeHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _gradientController;

  @override
  void initState() {
    super.initState();
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _gradientController.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  IconData _getGreetingIcon() {
    final hour = DateTime.now().hour;
    if (hour < 12) return FeatherIcons.sunrise;
    if (hour < 17) return FeatherIcons.sun;
    return "Good Evening" != "" ? FeatherIcons.moon : FeatherIcons.moon;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr = DateFormat('EEEE, MMM d, yyyy').format(now);

    return AnimatedBuilder(
      animation: _gradientController,
      builder: (context, child) {
        final t = _gradientController.value;
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment(
                -1.0 + t * 0.5,
                -1.0 + t * 0.3,
              ),
              end: Alignment(
                1.0 - t * 0.3,
                1.0 - t * 0.5,
              ),
              colors: const [
                Color(0xFF1A1D2E),
                Color(0xFF2D3250),
                Color(0xFF424769),
              ],
              stops: [
                0.0,
                0.4 + t * 0.2,
                1.0,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1A1D2E).withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: ColorConst.violate.withValues(alpha: 0.15),
                blurRadius: 30,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        );
      },
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),
          Positioned(
            right: 30,
            bottom: -30,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.03),
              ),
            ),
          ),

          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Avatar with initials
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          ColorConst.violate,
                          ColorConst.sidebarSelected
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: ColorConst.violate.withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: CustomText(
                        F.title.isNotEmpty ? F.title[0].toUpperCase() : "D",
                        color: Colors.white,
                        size: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  16.pw,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _getGreetingIcon(),
                              color: const Color(0xFFFFD700),
                              size: 16,
                            ),
                            6.pw,
                            CustomText(
                              _getGreeting(),
                              color: Colors.white.withValues(alpha: 0.7),
                              size: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                        4.ph,
                        CustomText(
                          context.l10n.hello_world,
                          color: Colors.white,
                          size: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                  ),

                  // Counter button
                  ValueListenableBuilder<int>(
                    valueListenable: widget.counter,
                    builder: (BuildContext context, int value, Widget? child) {
                      return _AnimatedCounterButton(
                        value: value,
                        onTap: () {
                          widget.counter.value = widget.counter.value + 1;
                        },
                      );
                    },
                  ),
                ],
              ),
              16.ph,
              // Date and flavor info row
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Wrap(
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      FeatherIcons.calendar,
                      color: Colors.white.withValues(alpha: 0.5),
                      size: 14,
                    ),
                    8.pw,
                    CustomText(
                      dateStr,
                      color: Colors.white.withValues(alpha: 0.6),
                      size: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    16.pw,
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                    ),
                    16.pw,
                    CustomText(
                      "${F.title} • ${F.name}",
                      color: Colors.white.withValues(alpha: 0.5),
                      size: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AnimatedCounterButton extends StatefulWidget {
  const _AnimatedCounterButton({
    required this.value,
    required this.onTap,
  });

  final int value;
  final VoidCallback onTap;

  @override
  State<_AnimatedCounterButton> createState() => _AnimatedCounterButtonState();
}

class _AnimatedCounterButtonState extends State<_AnimatedCounterButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) {
        _scaleController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _scaleController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.15),
                Colors.white.withValues(alpha: 0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(FeatherIcons.activity, color: Colors.white, size: 16),
              8.pw,
              CustomText(
                "${widget.value}",
                color: Colors.white,
                fontWeight: FontWeight.w600,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
