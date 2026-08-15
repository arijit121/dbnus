import 'dart:ui';
import 'package:material_ui/material_ui.dart';
import 'package:dbnus/shared/constants/assects_const.dart';
import 'package:dbnus/shared/ui/atoms/images/custom_image.dart';

import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';

class LeaderboardUser {
  final String id;
  final String name;
  final int points;
  final int rankChange; // positive for up, negative for down, 0 for same
  final String avatarInitials;

  LeaderboardUser({
    required this.id,
    required this.name,
    required this.points,
    required this.rankChange,
    required this.avatarInitials,
  });
}

class RankingList extends StatefulWidget {
  const RankingList({super.key});

  @override
  State<RankingList> createState() => _RankingListState();
}

class _RankingListState extends State<RankingList> {
  final List<LeaderboardUser> _users = [
    LeaderboardUser(
        id: "1",
        name: "Alex Rivera",
        points: 4820,
        rankChange: 2,
        avatarInitials: "AR"),
    LeaderboardUser(
        id: "2",
        name: "Sophia Chen",
        points: 4250,
        rankChange: -1,
        avatarInitials: "SC"),
    LeaderboardUser(
        id: "3",
        name: "Marcus Vance",
        points: 3980,
        rankChange: 0,
        avatarInitials: "MV"),
    LeaderboardUser(
        id: "4",
        name: "Elena Rostova",
        points: 3450,
        rankChange: 3,
        avatarInitials: "ER"),
    LeaderboardUser(
        id: "5",
        name: "Jordan Blake",
        points: 3120,
        rankChange: -2,
        avatarInitials: "JB"),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor =
        isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    final cardBg = isDark ? const Color(0xFF131520) : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomSvgAssetImageView(
              path: AssetsConst.featherList,
              height: 18,
              width: 18,
              color: isDark ? const Color(0xFFF8FAFC) : ColorConst.primaryDark,
            ),
            10.pw,
            CustomText(
              "Global Rankings",
              fontWeight: FontWeight.w600,
              size: 16,
              color: isDark ? const Color(0xFFF8FAFC) : ColorConst.primaryDark,
            ),
          ],
        ),
        12.ph,
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.3)
                      : Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: ReorderableListView.builder(
              shrinkWrap: true,
              itemCount: _users.length,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final user = _users.removeAt(oldIndex);
                  _users.insert(newIndex, user);
                });
              },
              proxyDecorator: (child, index, animation) {
                return AnimatedBuilder(
                  animation: animation,
                  builder: (BuildContext context, Widget? child) {
                    final double animValue =
                        Curves.easeInOut.transform(animation.value);
                    final double scale = lerpDouble(1, 1.02, animValue)!;
                    return Transform.scale(
                      scale: scale,
                      child: Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(10),
                        shadowColor: ColorConst.baseHexColor.withOpacity(0.3),
                        child: child,
                      ),
                    );
                  },
                  child: child,
                );
              },
              itemBuilder: (context, index) {
                final user = _users[index];
                return Container(
                  key: Key(user.id),
                  decoration: BoxDecoration(
                    color: cardBg,
                    border: Border(
                      bottom: BorderSide(
                        color: index < _users.length - 1
                            ? borderColor
                            : Colors.transparent,
                        width: 1,
                      ),
                    ),
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Drag handle icon on the left
                        ReorderableDragStartListener(
                          index: index,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Icon(
                              Icons.drag_indicator_rounded,
                              color: isDark ? Colors.white24 : Colors.black26,
                              size: 20,
                            ),
                          ),
                        ),
                        // Rank badge
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: _getRankColor(index)
                                .withOpacity(isDark ? 0.15 : 0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: CustomText(
                              "#${index + 1}",
                              fontWeight: FontWeight.w700,
                              size: 13,
                              color: _getRankColor(index),
                            ),
                          ),
                        ),
                      ],
                    ),
                    title: CustomText(
                      user.name,
                      fontWeight: FontWeight.w600,
                      size: 14,
                      color: isDark
                          ? const Color(0xFFF8FAFC)
                          : ColorConst.primaryDark,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Rank change trend icon
                        _buildTrendIndicator(user.rankChange),
                        8.pw,
                        // Points indicator
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: CustomText(
                            "${user.points} pts",
                            size: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF64748B),
                          ),
                        ),
                        
                        // Delete/Remove button
                        IconButton(
                          icon: const CustomSvgAssetImageView(
                            path: AssetsConst.featherTrash2,
                            height: 16,
                            width: 16,
                            color: ColorConst.red,
                          ),
                          onPressed: () {
                            setState(() {
                              _users.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrendIndicator(int change) {
    if (change > 0) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.arrow_drop_up_rounded,
              color: Color(0xFF10B981), size: 20),
          CustomText(
            "$change",
            size: 11,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF10B981),
          ),
        ],
      );
    } else if (change < 0) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.arrow_drop_down_rounded,
              color: ColorConst.red, size: 20),
          CustomText(
            "${change.abs()}",
            size: 11,
            fontWeight: FontWeight.w700,
            color: ColorConst.red,
          ),
        ],
      );
    } else {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 6),
        child: CustomText(
          "—",
          size: 11,
          fontWeight: FontWeight.w700,
          color: Color(0xFF94A3B8),
        ),
      );
    }
  }

  Color _getRankColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFFFFB300); // Gold
      case 1:
        return const Color(0xFF94A3B8); // Silver
      case 2:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return ColorConst.baseHexColor;
    }
  }
}
