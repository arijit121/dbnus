import 'dart:ui';

import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/navigation/router_name.dart';
import 'package:dbnus/core/storage/localCart/bloc/local_cart_bloc.dart';
import 'package:dbnus/core/storage/localCart/model/cart_service_model.dart';
import 'package:dbnus/shared/ui/atoms/buttons/custom_button.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:dbnus/shared/ui/organisms/scrolls/smooth_scroll.dart';

class LeaderBoard extends StatefulWidget {
  const LeaderBoard({super.key});

  @override
  State<LeaderBoard> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  List<String> items = List.generate(5, (index) => 'Item ${index + 1}');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Header ──────────────────────────────────────────
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1B7A4D),
                ColorConst.deepGreen,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: ColorConst.deepGreen.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(FeatherIcons.award, color: Colors.white, size: 24),
              ),
              16.pw,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      "Leaderboard",
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      size: 22,
                    ),
                    4.ph,
                    CustomText(
                      "Drag to reorder items",
                      color: Colors.white70,
                      size: 13,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        16.ph,

        // ── Quick Actions ───────────────────────────────────
        Row(
          children: [
            Icon(FeatherIcons.zap, size: 20, color: ColorConst.primaryDark),
            10.pw,
            CustomText(
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
                gradient: [ColorConst.violate, ColorConst.sidebarSelected],
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
                gradient: [ColorConst.lightBlue, ColorConst.deepBlue],
                onTap: () {
                  kIsWeb
                      ? context.goNamed(RouteName.order)
                      : context.pushNamed(RouteName.order);
                },
              ),
            ),
          ],
        ),
        16.ph,

        // ── Reorderable List ────────────────────────────────
        Row(
          children: [
            Icon(FeatherIcons.list, size: 20, color: ColorConst.primaryDark),
            10.pw,
            CustomText(
              "Ranking",
              fontWeight: FontWeight.w600,
              size: 18,
              color: ColorConst.primaryDark,
            ),
          ],
        ),
        12.ph,
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: ColorConst.cardBg,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: ReorderableListView(
              shrinkWrap: true,
              buildDefaultDragHandles: true,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final item = items.removeAt(oldIndex);
                  items.insert(newIndex, item);
                });
              },
              proxyDecorator: (child, index, animation) {
                return AnimatedBuilder(
                  animation: animation,
                  builder: (BuildContext context, Widget? child) {
                    final double animValue =
                        Curves.easeInOut.transform(animation.value);
                    final double scale = lerpDouble(1, 1.05, animValue)!;
                    return Transform.scale(
                      scale: scale,
                      child: Material(
                        elevation: 6,
                        borderRadius: BorderRadius.circular(12),
                        shadowColor:
                            ColorConst.sidebarSelected.withValues(alpha: 0.3),
                        child: child,
                      ),
                    );
                  },
                  child: child,
                );
              },
              children: List.generate(
                items.length,
                (index) => Container(
                  key: Key('$index'),
                  decoration: BoxDecoration(
                    border: index < items.length - 1
                        ? Border(
                            bottom: BorderSide(
                                color: ColorConst.lineGrey, width: 1))
                        : null,
                  ),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: _getRankColor(index).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: CustomText(
                          "#${index + 1}",
                          fontWeight: FontWeight.w700,
                          size: 14,
                          color: _getRankColor(index),
                        ),
                      ),
                    ),
                    title: CustomText(
                      items[index],
                      fontWeight: FontWeight.w600,
                      size: 15,
                      color: ColorConst.primaryDark,
                    ),
                    trailing: IconButton(
                      icon: Icon(FeatherIcons.trash2,
                          size: 18, color: ColorConst.red),
                      onPressed: () {
                        setState(() {
                          items.removeAt(index);
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
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
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(6),
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

  Color _getRankColor(int index) {
    switch (index) {
      case 0:
        return Color(0xFFFFB300); // Gold
      case 1:
        return ColorConst.blueGrey; // Silver
      case 2:
        return Color(0xFFCD7F32); // Bronze
      default:
        return ColorConst.violate;
    }
  }
}
