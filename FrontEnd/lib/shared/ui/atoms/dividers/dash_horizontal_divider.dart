import 'package:flutter/material.dart';

import 'package:dbnus/shared/constants/color_const.dart';

class DashHorizontalDivider extends StatelessWidget {
  const DashHorizontalDivider(
      {super.key, this.height = 1, this.separatedWidth = 10, this.color});

  final double height;
  final double separatedWidth;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = separatedWidth;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration:
                    BoxDecoration(color: color ?? ColorConst.primaryDark),
              ),
            );
          }),
        );
      },
    );
  }
}
