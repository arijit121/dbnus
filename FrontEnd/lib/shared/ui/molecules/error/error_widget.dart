import 'package:flutter/material.dart';

import 'package:dbnus/shared/constants/assects_const.dart';
import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:dbnus/shared/ui/atoms/images/custom_image.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget(
      {super.key,
      this.height = 300,
      this.width = 300,
      this.backgroundColor = Colors.transparent,
      this.errorMsg});

  final double width;
  final double height;
  final Color? backgroundColor;
  final String? errorMsg;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      width: width,
      height: height,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomAssetImageView(
              path: AssetsConst.somethingWentWrong,
              height: height - 20,
            ),
            if (errorMsg?.isNotEmpty == true)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: CustomText(errorMsg ?? "",
                    color: ColorConst.grey, size: 13),
              )
          ],
        ),
      ),
    );
  }
}
