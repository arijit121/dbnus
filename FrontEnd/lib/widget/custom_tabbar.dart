import 'package:flutter/material.dart';
import 'package:genu/extension/spacing.dart';
import 'package:genu/widget/custom_button.dart';
import 'package:genu/widget/custom_text.dart';

Widget customTabBar(
        {required Color inactiveColor,
        required Color activeColor,
        required String title,
        required bool isActive,
        void Function()? onPressed}) =>
    customTextButton(
      child: Column(
        children: [
          customText(title, isActive ? activeColor : inactiveColor, 14,
              fontWeight: isActive ? FontWeight.w500 : FontWeight.w400),
          7.ph,
          Container(
            width: (title.length * 8)+9,
            height: 2,
            decoration: BoxDecoration(
                color: isActive ? activeColor : Colors.transparent,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
          )
        ],
      ),
      onPressed: onPressed,
    );
