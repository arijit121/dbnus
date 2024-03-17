import 'package:flutter/material.dart';
import '../extension/spacing.dart';
import '../widget/custom_button.dart';
import '../widget/custom_text.dart';

Widget customTabBar(
        {required Color inactiveColor,
        required Color activeColor,
        required String title,
        required bool isActive,
        void Function()? onPressed}) =>
    customTextButton(
      child: Column(
        children: [
          customText(title,
              color: isActive ? activeColor : inactiveColor,
              size: 14,
              fontWeight: isActive ? FontWeight.w500 : FontWeight.w400),
          7.ph,
          Container(
            width: (title.length * 8) + 9,
            height: 2,
            decoration: BoxDecoration(
                color: isActive ? activeColor : Colors.transparent,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
          )
        ],
      ),
      onPressed: onPressed,
    );
