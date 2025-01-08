import 'package:flutter/material.dart';

import '../const/assects_const.dart';
import 'custom_image.dart';

class InitWidget extends StatelessWidget {
  const InitWidget(
      {super.key,
      this.height = 300,
      this.width = 300,
      this.backgroundColor = Colors.transparent});

  final double width;
  final double height;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      width: width,
      height: height,
      child: CustomAssetImageView(
        path: AssetsConst.dbnusNoImageLogo,
        height: 60,
        width: 60,
      ),
    );
  }
}
