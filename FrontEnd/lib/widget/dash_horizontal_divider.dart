import 'package:flutter/material.dart';

import '../const/color_const.dart';
import '../extension/hex_color.dart';

class DashHorizontalDivider extends StatelessWidget {
  const DashHorizontalDivider(
      {super.key,
      this.height = 1,
      this.saparetedWidth = 10,
      this.color = Colors.black});

  final double height;
  final double saparetedWidth;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = saparetedWidth;
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
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}
