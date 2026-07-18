import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:dbnus/shared/constants/assects_const.dart';

import 'package:dbnus/navigation/router_name.dart';
import 'package:dbnus/core/localization/utils/localization_utils.dart';
import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:dbnus/shared/ui/atoms/images/custom_image.dart';
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
        icon: AssetsConst.featherGlobe,
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
        icon: AssetsConst.featherFileText,
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
        icon: AssetsConst.featherBarChart2,
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
        icon: AssetsConst.featherUploadCloud,
        label: "File Pick",
        subtitle: "Upload files",
        gradient: const [Color(0xFFE67E22), Color(0xFFD35400)],
        onTap: () async {
          CustomFile? customFile = await CustomFilePicker.customFilePicker();
          AppLog.i(customFile?.name, tag: "CustomFile");
        },
      ),
      _QuickAction(
        icon: AssetsConst.featherSmartphone,
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
        icon: AssetsConst.featherDollarSign,
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = widget.action.gradient.first;

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
            color: isDark ? const Color(0xFF131520) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icon with subtle matching tint background
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(isDark ? 0.15 : 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: CustomSvgAssetImageView(
                      path: widget.action.icon,
                      color: accentColor,
                      height: 18,
                      width: 18,
                    ),
                  ),
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
                            color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
                            fontWeight: FontWeight.w600,
                            size: 13,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          4.ph,
                          CustomText(
                            widget.action.subtitle,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            fontWeight: FontWeight.w400,
                            size: 11,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    CustomSvgAssetImageView(
                      path: AssetsConst.featherArrowRight,
                      color: isDark ? Colors.white.withOpacity(0.3) : ColorConst.secondaryDark.withOpacity(0.4),
                      height: 14,
                      width: 14,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickAction {
  final String icon;
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
