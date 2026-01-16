import 'package:dbnus/core/extensions/spacing.dart';
import 'package:dbnus/shared/ui/atoms/images/custom_image.dart';
import 'package:flutter/material.dart';

import 'package:dbnus/core/constants/assects_const.dart';
import 'package:dbnus/core/services/value_handler.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';

class NoDataFound extends StatelessWidget {
  const NoDataFound(
      {super.key,
      this.height = 300,
      this.width = 300,
      this.backgroundColor = Colors.transparent,
      this.msg});

  final double width;
  final double height;
  final Color? backgroundColor;
  final String? msg;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: backgroundColor,
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            30.ph,
            CustomAssetImageView(
              path: AssetsConst.noRecordFound,
              width: width - 20,
              height: height -
                  (80 + 44 + (ValueHandler.isTextNotEmptyOrNull(msg) ? 20 : 0)),
            ),
            const CustomText(
              "No record found",
              color: Colors.blue,
              size: 36,
              fontWeight: FontWeight.w600,
            ),
            30.ph,
            if (ValueHandler.isTextNotEmptyOrNull(msg))
              CustomText(msg ?? "", color: Colors.blue, size: 20),
          ],
        ),
      ),
    );
  }
}
