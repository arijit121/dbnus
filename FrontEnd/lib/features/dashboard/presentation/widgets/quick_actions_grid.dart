import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:feather_icons/feather_icons.dart';

import 'package:dbnus/navigation/router_name.dart';
import 'package:dbnus/core/localization/utils/localization_utils.dart';
import 'package:dbnus/shared/constants/color_const.dart';
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
        gradient: const [Color(0xFFE67E22), Color(0xFFD35400)],
        onTap: () async {
          CustomFile? customFile = await CustomFilePicker.customFilePicker();
          AppLog.i(customFile?.name, tag: "CustomFile");
        },
      ),
      _QuickAction(
        icon: FeatherIcons.smartphone,
        label: "Device ID",
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
            aspectRatio: 1.6,
            child: _buildActionCard(action),
          );
        },
      );
    });
  }

  Widget _buildActionCard(_QuickAction action) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: action.onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: action.gradient,
            ),
            boxShadow: [
              BoxShadow(
                color: action.gradient.first.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(action.icon, color: Colors.white, size: 20),
              ),
              CustomText(
                action.label,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                size: 13,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
  final List<Color> gradient;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });
}
