import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:provider/provider.dart';
import 'package:retailer_shakti/resources/color/custom_color.dart';
import 'package:retailer_shakti/resources/text/custom_textStyle.dart';
import 'package:retailer_shakti/resources/text/localization_keys.dart';

import '../../../resources/components/html_renderer.dart';
import '../../../resources/text/app_text.dart';
import '../utils/crashUtils.dart';
import '../viewModel/crashViewModel.dart';

class CrashUi extends StatelessWidget {
  CrashUi({super.key, this.errorDetails});

  Map<String, dynamic>? errorDetails;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          await CrashUtils().setValue(value: false);
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 2,
            backgroundColor: Colors.grey.shade100,
            title: Image.asset("assets/logo/retailer_shakti_logo_color.png"),
            centerTitle: true,
          ),
          body: ChangeNotifierProvider(
            create: (_) => CrashViewModel(errorDetails: errorDetails),
            child: Consumer<CrashViewModel>(builder: (context, crash, widget) {
              return Column(
                children: [
                  Image.asset("assets/images/sadBot.png"),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: HtmlToDart(
                        htmlText: tr(LocalizationKeys.crashMassage),
                      )),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      CrashUtils().setValue(value: false);
                      Platform.isAndroid
                          ? SystemNavigator.pop()
                          : FlutterExitApp.exitApp(iosForceExit: false);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          color: blue,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Center(
                        child:
                            customText(AppEnglishTexts().sendReport, white, 18),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
