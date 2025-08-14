import 'package:dbnus/extension/spacing.dart';
import 'package:flutter/material.dart';

import '../const/assects_const.dart';
import '../const/color_const.dart';
import '../router/custom_router/custom_route.dart';
import '../router/router_name.dart';
import '../utils/text_utils.dart';
import 'custom_button.dart';
import 'custom_image.dart';
import 'custom_text.dart';

class ErrorRouteWidget extends StatelessWidget {
  const ErrorRouteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: CustomText(TextUtils.notFound,
            color: ColorConst.primaryDark, size: 20),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CustomAssetImageView(
                path: AssetsConst.pageNotFound,
                height: 200,
                width: 200,
              ),
              8.ph,
              CustomText(
                'Oops! Something went wrong...',
                color: ColorConst.primaryDark,
                size: 20,
              ),
              8.ph,
              CustomText(
                '404',
                color: ColorConst.primaryDark,
                size: 50,
              ),
              8.ph,
              CustomText(
                'Page Not Found',
                color: ColorConst.primaryDark,
                size: 20,
              ),
              12.ph,
              CustomGOEButton(
                radius: 6,
                backGroundColor: Colors.blueAccent,
                onPressed: () {
                  CustomRoute.clearAndNavigateName(RouteName.initialView);
                },
                child: const CustomText(
                  "Back to Home",
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
