import 'package:dbnus/const/assects_const.dart';
import 'package:dbnus/const/color_const.dart';
import 'package:dbnus/extension/hex_color.dart';
import 'package:dbnus/extension/spacing.dart';
import 'package:dbnus/utils/screen_utils.dart';
import 'package:dbnus/utils/text_utils.dart';
import 'package:dbnus/widget/custom_button.dart';
import 'package:dbnus/widget/custom_image.dart';
import 'package:dbnus/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/crashUtils.dart';

class CrashUi extends StatelessWidget {
  const CrashUi({super.key, this.errorDetails});

  final Map<String, dynamic>? errorDetails;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        await CrashUtils().setValue(value: false);
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 2,
          backgroundColor: Colors.grey.shade100,
          title: CustomAssetImageView(
            path: AssetsConst.dbnusNoImageLogo,
            height: 48,
          ),
        ),
        body: SafeArea(
          child: ResponsiveBuilder(builder: (context, widthState) {
            return Column(
              children: [
                CustomAssetImageView(
                  path: AssetsConst.somethingWentWrong,
                  height: ScreenUtils.nh() * 0.5,
                ),
                const Spacer(),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CustomHtmlText(
                      TextUtils.crashMassage,
                      color: ColorConst.primaryDark,
                    )),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CustomGOEButton(
                    backGroundColor: Colors.blue,
                    radius: 8,
                    size: const Size(double.infinity, 60),
                    onPressed: () async {
                      await CrashUtils().setValue(value: false);
                      SystemNavigator.pop();
                    },
                    child: Center(
                      child: CustomText(
                        TextUtils.sendReport,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
                20.ph,
              ],
            );
          }),
        ),
      ),
    );
  }
}
