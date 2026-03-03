import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:feather_icons/feather_icons.dart';

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
    return Column(
      children: [
        Row(
          children: [
            const Icon(FeatherIcons.zap,
                size: 20, color: ColorConst.primaryDark),
            10.pw,
            const CustomText(
              "Quick Actions",
              fontWeight: FontWeight.w600,
              size: 18,
              color: ColorConst.primaryDark,
            ),
          ],
        ),
        12.ph,
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: FeatherIcons.shoppingCart,
                label: "Add to Cart",
                gradient: const [
                  ColorConst.violate,
                  ColorConst.sidebarSelected
                ],
                onTap: () {
                  context.read<LocalCartBloc>().add(AddServiceToCart(
                          serviceModel: CartServiceModel(
                        serviceId: "hvsdhvfshv",
                        price: 20.6,
                      )));
                },
              ),
            ),
            12.pw,
            Expanded(
              child: _buildActionCard(
                icon: FeatherIcons.package,
                label: "Go to Orders",
                gradient: const [ColorConst.lightBlue, ColorConst.deepBlue],
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
    required IconData icon,
    required String label,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          height: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradient,
            ),
            boxShadow: [
              BoxShadow(
                color: gradient.first.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.white, size: 18),
              ),
              CustomText(
                label,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                size: 13,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
