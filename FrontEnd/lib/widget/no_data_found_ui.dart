import 'package:dbnus/extension/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../const/assects_const.dart';
import '../service/value_handler.dart';
import '../utils/screen_utils.dart';
import 'custom_text.dart';

class NoDataFound extends StatelessWidget {
  final String? msg;
  final Widget? widget;

  const NoDataFound({super.key, this.msg, this.widget});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: ScreenUtils.aw(),
        child: Column(
          children: [
            30.ph,
            SvgPicture.asset(
              AssetsConst.emptyFile,
              allowDrawingOutsideViewBox: true,
            ),
            30.ph,
            if (ValueHandler().isTextNotEmptyOrNull(msg))
              CustomText(msg ?? "", color: Colors.blue, size: 20),
            if (widget != null) ...[5.ph, widget!],
          ],
        ),
      ),
    );
  }
}
