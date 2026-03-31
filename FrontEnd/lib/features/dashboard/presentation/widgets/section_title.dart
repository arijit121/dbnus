import 'package:flutter/material.dart';

import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    required this.icon,
    this.trailing,
  });

  final String title;
  final IconData icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Accent bar
        Container(
          width: 4,
          height: 28,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [ColorConst.violate, ColorConst.sidebarSelected],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        10.pw,
        // Icon with soft background circle
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: ColorConst.violate.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: ColorConst.violate),
        ),
        10.pw,
        Expanded(
          child: CustomText(
            title,
            fontWeight: FontWeight.w700,
            size: 18,
            color: ColorConst.primaryDark,
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
