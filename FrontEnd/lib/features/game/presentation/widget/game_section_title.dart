import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:flutter/material.dart';

class GameSectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const GameSectionTitle({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: ColorConst.primaryDark),
        10.pw,
        CustomText(title,
            fontWeight: FontWeight.w600,
            size: 18,
            color: ColorConst.primaryDark),
      ],
    );
  }
}
