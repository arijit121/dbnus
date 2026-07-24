import 'package:dbnus/shared/constants/assects_const.dart';
import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/utils/screen_utils.dart';
import 'package:dbnus/shared/utils/text_utils.dart';
import 'package:dbnus/shared/ui/atoms/buttons/custom_button.dart';
import 'package:dbnus/shared/ui/atoms/images/custom_image.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:dbnus/navigation/custom_router/custom_route.dart';
import 'package:dbnus/navigation/router_name.dart';
import 'package:dbnus/core/services/crash/utils/crash_utils.dart';

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
                    borderRadius: BorderRadius.circular(8),
                    width: double.infinity,
                    onPressed: () async {
                      await CrashUtils.setValue(value: false);
                      await CrashUtils.logCrash(args: errorDetails);
                      kIsWeb
                          ? CustomRoute.clearAndNavigateName(
                              RouteName.initialView)
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
