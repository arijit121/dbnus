import 'package:dbnus/const/assects_const.dart';
import 'package:dbnus/const/color_const.dart';
import 'package:dbnus/extension/spacing.dart';
import 'package:dbnus/utils/screen_utils.dart';
import 'package:dbnus/utils/text_utils.dart';
import 'package:dbnus/widget/custom_button.dart';
import 'package:dbnus/widget/custom_image.dart';
import 'package:dbnus/widget/custom_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../router/custom_router/custom_route.dart';
import '../../../router/router_name.dart';
import '../utils/crash_utils.dart';

class CrashUi extends StatelessWidget {
  const CrashUi({super.key, this.errorDetails});

  final Map<String, dynamic>? errorDetails;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        await CrashUtils.setValue(value: false);
        await CrashUtils.logCrash(args: errorDetails);
        kIsWeb
            ? CustomRoute.clearAndNavigateName(RouteName.initialView)
            : SystemNavigator.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 2,
          titleSpacing: 12,
          // backgroundColor: Colors.grey.shade100,
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
                    width: double.infinity,
                    onPressed: () async {
                      await CrashUtils.setValue(value: false);
                      await CrashUtils.logCrash(args: errorDetails);
                      kIsWeb
                          ? CustomRoute.clearAndNavigateName(RouteName.initialView)
                          : SystemNavigator.pop();
                      await CrashUtils.setValue(value: false);
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
