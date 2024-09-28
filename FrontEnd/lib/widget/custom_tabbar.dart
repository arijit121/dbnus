import 'package:flutter/material.dart';

import '../extension/spacing.dart';
import '../widget/custom_button.dart';
import '../widget/custom_text.dart';

class CustomTabBar extends StatelessWidget {
  final Color inactiveColor;
  final Color activeColor;
  final String title;
  final bool isActive;
  final VoidCallback? onPressed;

  const CustomTabBar({
    super.key,
    required this.inactiveColor,
    required this.activeColor,
    required this.title,
    required this.isActive,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextButton(
      onPressed: onPressed,
      child: Column(
        children: [
          CustomText(
            title,
            color: isActive ? activeColor : inactiveColor,
            size: 14,
            fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
          ),
          7.ph,
          Container(
            width: (title.length * 8) + 9,
            height: 2,
            decoration: BoxDecoration(
              color: isActive ? activeColor : Colors.transparent,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }
}
