import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:feather_icons/feather_icons.dart';

import 'package:dbnus/navigation/router_name.dart';
import 'package:dbnus/core/localization/utils/localization_utils.dart';
import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:dbnus/core/models/custom_file.dart';
import 'package:dbnus/core/services/file_picker.dart';
import 'package:dbnus/shared/extensions/logger_extension.dart';
import 'package:dbnus/core/config/app_config.dart';
import 'package:dbnus/shared/utils/pop_up_items.dart';
import 'package:dbnus/navigation/custom_router/custom_route.dart';
import 'package:dbnus/core/network/models/razorpay_merchant_details.dart';
import 'package:dbnus/shared/ui/organisms/grids/custom_grid_view.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickAction(
        icon: FeatherIcons.globe,
        label: "Change Language",
        subtitle: "Random locale",
        gradient: const [ColorConst.violate, ColorConst.sidebarSelected],
        onTap: () {
          LocalizationUtils.changeLanguage(
              locale: LocalizationUtils.supportedLocales[
                  Random().nextInt(LocalizationUtils.supportedLocales.length)]);
        },
      ),
      _QuickAction(
        icon: FeatherIcons.fileText,
        label: "Order Details",
        subtitle: "View order #56",
        gradient: const [ColorConst.lightBlue, ColorConst.deepBlue],
        onTap: () {
          kIsWeb
              ? context.goNamed(RouteName.orderDetails,
                  pathParameters: {"order_id": "56"})
              : context.pushNamed(RouteName.orderDetails,
                  pathParameters: {"order_id": "56"});
        },
      ),
      _QuickAction(
        icon: FeatherIcons.barChart2,
        label: "Leaderboard",
        subtitle: "Rankings",
        gradient: const [ColorConst.deepGreen, Color(0xFF1B7A4D)],
        onTap: () {
          kIsWeb
              ? context.goNamed(RouteName.leaderBoard)
              : context.pushNamed(RouteName.leaderBoard);
        },
      ),
      _QuickAction(
        icon: FeatherIcons.uploadCloud,
        label: "File Pick",
        subtitle: "Upload files",
        gradient: const [Color(0xFFE67E22), Color(0xFFD35400)],
        onTap: () async {
          CustomFile? customFile = await CustomFilePicker.customFilePicker();
          AppLog.i(customFile?.name, tag: "CustomFile");
        },
      ),
      _QuickAction(
        icon: FeatherIcons.smartphone,
        label: "Device ID",
        subtitle: "Copy identifier",
        gradient: const [Color(0xFF8E44AD), Color(0xFF6C3483)],
        onTap: () async {
          String? deviceId = await AppConfig().getDeviceId();
          AppLog.i(deviceId);
          PopUpItems.toastMessage(deviceId ?? "", Colors.green);
        },
      ),
      _QuickAction(
        icon: FeatherIcons.dollarSign,
        label: "Razorpay",
        subtitle: "Payment",
        gradient: const [ColorConst.lightBlue, ColorConst.violate],
        onTap: () async {
          CustomRoute.pushNamed(
              name: RouteName.rayzorPay, arguments: RazorpayMerchantDetails());
        },
      ),
    ];

    return LayoutBuilder(builder: (context, constraints) {
      int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
      return CustomGridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemCount: actions.length,
        builder: (context, index) {
          final action = actions[index];
          return AspectRatio(
            aspectRatio: 1.25,
            child: _QuickActionCard(action: action),
          );
        },
      );
    });
  }
}

class _QuickActionCard extends StatefulWidget {
  const _QuickActionCard({required this.action});
  final _QuickAction action;

  @override
  State<_QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<_QuickActionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.action.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.action.gradient,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.action.gradient.first.withValues(alpha: 0.35),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Decorative circles for depth/texture
              Positioned(
                right: -15,
                top: -15,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
              ),
              Positioned(
                right: 20,
                bottom: -10,
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Icon with glow
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.1),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Icon(widget.action.icon,
                          color: Colors.white, size: 20),
                    ),

                    // Label + subtitle + chevron row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                widget.action.label,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                size: 13,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              2.ph,
                              CustomText(
                                widget.action.subtitle,
                                color: Colors.white.withValues(alpha: 0.7),
                                fontWeight: FontWeight.w400,
                                size: 11,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          FeatherIcons.arrowRight,
                          color: Colors.white.withValues(alpha: 0.5),
                          size: 14,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final String subtitle;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });
}
