import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dbnus/shared/constants/assects_const.dart';
import 'package:dbnus/shared/ui/atoms/images/custom_image.dart';

import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:dbnus/navigation/router_name.dart';
import 'package:dbnus/core/storage/localCart/bloc/local_cart_bloc.dart';
import 'package:dbnus/core/storage/localCart/model/cart_service_model.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomSvgAssetImageView(
              path: AssetsConst.featherZap,
              height: 18,
              width: 18,
              color: isDark ? const Color(0xFFF8FAFC) : ColorConst.primaryDark,
            ),
            10.pw,
            CustomText(
              "Quick Actions",
              fontWeight: FontWeight.w600,
              size: 16,
              color: isDark ? const Color(0xFFF8FAFC) : ColorConst.primaryDark,
            ),
          ],
        ),
        12.ph,
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context: context,
                icon: AssetsConst.featherShoppingCart,
                label: "Add to Cart",
                accentColor: ColorConst.baseHexColor,
                onTap: () {
                  context.read<LocalCartBloc>().add(AddServiceToCart(
                        serviceModel: CartServiceModel(
                          serviceId: "hvsdhvfshv",
                          price: 20.6,
                        ),
                      ));
                },
              ),
            ),
            12.pw,
            Expanded(
              child: _buildActionCard(
                context: context,
                icon: AssetsConst.featherPackage,
                label: "Go to Orders",
                accentColor: const Color(0xFF0EA5E9), // Clean blue
                onTap: () {
                  kIsWeb
                      ? context.goNamed(RouteName.order)
                      : context.pushNamed(RouteName.order);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required String icon,
    required String label,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    final cardBg = isDark ? const Color(0xFF131520) : Colors.white;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(isDark ? 0.15 : 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CustomSvgAssetImageView(
                  path: icon,
                  color: accentColor,
                  height: 18,
                  width: 18,
                ),
              ),
              16.pw,
              Expanded(
                child: CustomText(
                  label,
                  color: isDark ? const Color(0xFFF8FAFC) : ColorConst.primaryDark,
                  fontWeight: FontWeight.w600,
                  size: 14,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 12,
                color: isDark ? Colors.white24 : Colors.black26,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
