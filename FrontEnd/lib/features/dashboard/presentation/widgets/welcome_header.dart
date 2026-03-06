import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:dbnus/core/localization/extension/localization_ext.dart';
import 'package:dbnus/flavors.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({
    super.key,
    required this.counter,
  });

  final ValueNotifier<int> counter;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorConst.sidebarBg,
            const Color(0xFF2D3250),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: ColorConst.sidebarBg.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(FeatherIcons.home,
                    color: Colors.white, size: 24),
              ),
              16.pw,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      context.l10n.hello_world,
                      color: Colors.white,
                      size: 22,
                    ),
                    4.ph,
                    CustomText(
                      "${F.title} • ${F.name}",
                      color: Colors.white70,
                      size: 13,
                    ),
                  ],
                ),
              ),
              ValueListenableBuilder<int>(
                valueListenable: counter,
                builder: (BuildContext context, int value, Widget? child) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      counter.value = counter.value + 1;
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(FeatherIcons.activity,
                              color: Colors.white, size: 16),
                          8.pw,
                          CustomText(
                            "$value",
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
