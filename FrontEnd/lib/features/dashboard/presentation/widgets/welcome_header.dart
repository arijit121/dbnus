import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dbnus/shared/constants/assects_const.dart';
import 'package:dbnus/shared/ui/atoms/images/custom_image.dart';
import 'package:intl/intl.dart';
import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:dbnus/core/localization/extension/localization_ext.dart';
import 'package:dbnus/flavors.dart';
import 'package:dbnus/features/dashboard/presentation/bloc/dashboard_bloc.dart';

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

  String _getGreetingIcon() {
    final hour = DateTime.now().hour;
    if (hour < 12) return AssetsConst.featherSunrise;
    if (hour < 17) return AssetsConst.featherSun;
    return "Good Evening" != "" ? AssetsConst.featherMoon : AssetsConst.featherMoon;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr = DateFormat('EEEE, MMM d, yyyy').format(now);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFE2E8F0),
          width: 1,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? const [Color(0xFF141724), Color(0xFF0F111E)]
              : const [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.4) : Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
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
                          ColorConst.baseHexColor,
                          ColorConst.vibrateBlue,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: CustomText(
                        F.title.isNotEmpty ? F.title[0].toUpperCase() : "D",
                        color: Colors.white,
                        size: 18,
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
                            CustomSvgAssetImageView(
                              path: _getGreetingIcon(),
                              color: isDark ? const Color(0xFFFFD700) : const Color(0xFFF59E0B),
                              height: 14,
                              width: 14,
                            ),
                            6.pw,
                            CustomText(
                              _getGreeting(),
                              color: isDark ? Colors.white.withValues(alpha: 0.7) : ColorConst.secondaryDark,
                              size: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                        4.ph,
                        CustomText(
                          context.l10n.hello_world,
                          color: isDark ? Colors.white : ColorConst.primaryDark,
                          size: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                  ),

                  // Counter buttons in a sleek column
                  Column(
                    children: [
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
                      8.ph,
                      BlocBuilder<DashboardBloc, DashboardState>(
                        builder: (BuildContext context, DashboardState state) {
                          final value = state.counter.value ?? 0;
                          return _AnimatedCounterButton(
                            value: value,
                            onTap: () {
                              context.read<DashboardBloc>().add(IncrementCounter());
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              16.ph,
              // Date and flavor info row
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withValues(alpha: 0.04) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark ? Colors.white.withValues(alpha: 0.04) : const Color(0xFFE2E8F0),
                    width: 0.5,
                  ),
                ),
                child: Wrap(
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    CustomSvgAssetImageView(
                      path: AssetsConst.featherCalendar,
                      color: isDark ? Colors.white.withValues(alpha: 0.5) : ColorConst.secondaryDark,
                      height: 14,
                      width: 14,
                    ),
                    8.pw,
                    CustomText(
                      dateStr,
                      color: isDark ? Colors.white.withValues(alpha: 0.7) : ColorConst.secondaryDark,
                      size: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    16.pw,
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withValues(alpha: 0.3) : ColorConst.lightGrey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    16.pw,
                    CustomText(
                      "${F.title} • ${F.name}",
                      color: isDark ? Colors.white.withValues(alpha: 0.5) : ColorConst.secondaryDark.withValues(alpha: 0.8),
                      size: 12,
                      fontWeight: FontWeight.w500,
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
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.06) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFE2E8F0),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomSvgAssetImageView(
                path: AssetsConst.featherActivity,
                color: isDark ? Colors.white : ColorConst.primaryDark,
                height: 14,
                width: 14,
              ),
              8.pw,
              CustomText(
                "${widget.value}",
                color: isDark ? Colors.white : ColorConst.primaryDark,
                fontWeight: FontWeight.w600,
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
