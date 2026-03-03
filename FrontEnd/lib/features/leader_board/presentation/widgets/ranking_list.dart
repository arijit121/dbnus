import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';

import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';

class RankingList extends StatefulWidget {
  const RankingList({super.key});

  @override
  State<RankingList> createState() => _RankingListState();
}

class _RankingListState extends State<RankingList> {
  List<String> items = List.generate(5, (index) => 'Item ${index + 1}');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(FeatherIcons.list,
                size: 20, color: ColorConst.primaryDark),
            10.pw,
            const CustomText(
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
                  offset: const Offset(0, 2),
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
                        ? const Border(
                            bottom: BorderSide(
                                color: ColorConst.lineGrey, width: 1))
                        : null,
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                      icon: const Icon(FeatherIcons.trash2,
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

  Color _getRankColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFFFFB300); // Gold
      case 1:
        return ColorConst.blueGrey; // Silver
      case 2:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return ColorConst.violate;
    }
  }
}
