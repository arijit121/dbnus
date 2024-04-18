import 'package:flutter/material.dart';
import '../widget/custom_text.dart';

import '../const/assects_const.dart';
import 'custom_image.dart';

//ignore: must_be_immutable
class CustomErrorWidget extends StatelessWidget {
  CustomErrorWidget(
      {super.key,
      this.height = 300,
      this.width = 300,
      this.backgroundColor = Colors.transparent,
      this.errorMsg});

  double width;
  double height;
  Color? backgroundColor;
  String? errorMsg;

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
                child: customText(errorMsg ?? "", color: Colors.grey, size: 13),
              )
          ],
        ),
      ),
    );
  }
}
