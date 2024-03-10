import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genu/extension/spacing.dart';
import 'package:genu/widget/custom_text.dart';

import '../../../const/color_const.dart';
import '../../../extension/hex_color.dart';
import '../../../extension/logger_extension.dart';
import '../../../storage/local_preferences.dart';
import '../../../utils/screen_utils.dart';
import '../../../utils/text_utils.dart';
import '../../../widget/custom_button.dart';
import '../../../widget/custom_image.dart';
import '../../../widget/dots_indicator.dart';
import '../bloc/landing_bloc.dart';

class LandingUi extends StatelessWidget {
  const LandingUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ScreenUtils.responsiveUI(
            ui: customText(
              "narrowUI",
            ),
            mediumUI: customText(
              "mediumUI",
            ),
            largeUI: customText(
              "largeUI",
            )),
      ),
    )
        //   BlocProvider(
        //   create: (context) => LandingBloc()..add(InitiateSplash()),
        //   child: BlocBuilder<LandingBloc, LandingState>(
        //     builder: (context, state) {
        //       return Scaffold(
        //           body: SafeArea(
        //         child: Column(
        //           children: [
        //             SizedBox(
        //               height: ScreenUtils.nh - 161,
        //               child: Stack(
        //                 alignment: AlignmentDirectional.bottomCenter,
        //                 children: [
        //                   PageView.builder(
        //                     itemCount: state.bannerData.value?.data?.length ?? 0,
        //                     itemBuilder: (context, index) {
        //                       return customNetWorkImageView(
        //                         width: ScreenUtils.aw,
        //                         fit: BoxFit.fill,
        //                         url: state.bannerData.value?.data
        //                                 ?.elementAt(index) ??
        //                             "",
        //                       );
        //                     },
        //                     onPageChanged: (index) {
        //                       context
        //                           .read<LandingBloc>()
        //                           .add(UpdateBannerIndex(index: index));
        //                     },
        //                   ),
        //                   if (state.bannerData.value?.data?.isNotEmpty == true)
        //                     Padding(
        //                       padding: const EdgeInsets.only(bottom: 16.0),
        //                       child: DotsIndicator(
        //                         dotsCount:
        //                             state.bannerData.value?.data?.length ?? 0,
        //                         position: state.bannerIndex.value ?? 0,
        //                         decorator: DotsDecorator(
        //                           color: Colors.grey.shade300,
        //                           activeColor: Colors.white,
        //                           size: const Size(12.0, 6.0),
        //                           activeSize: const Size(24.0, 6.0),
        //                           shape: RoundedRectangleBorder(
        //                               borderRadius: BorderRadius.circular(5.0)),
        //                           activeShape: RoundedRectangleBorder(
        //                               borderRadius: BorderRadius.circular(5.0)),
        //                         ),
        //                       ),
        //                     )
        //                 ],
        //               ),
        //             ),
        //             Container(
        //               padding:
        //                   const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        //               child: Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   Row(
        //                     mainAxisAlignment: MainAxisAlignment.center,
        //                     children: [
        //                       Expanded(
        //                         child: customText(
        //                           TextUtils.need_immediate_medical_help,
        //                           HexColor.fromHex(ColorConst.primaryDark),
        //                           18,
        //                           fontWeight: FontWeight.bold,
        //                           textAlign: TextAlign.center,
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                   3.ph,
        //                   customText(
        //                     TextUtils.tap_green_button_to_connect_doctor,
        //                     Colors.grey,
        //                     14,
        //                     textAlign: TextAlign.center,
        //                   ),
        //                 ],
        //               ),
        //             ),
        //             customElevatedButton(
        //                 radius: 5,
        //                 minimumSize: Size(ScreenUtils.nw - (2 * 16), 40),
        //                 color: HexColor.fromHex(ColorConst.green),
        //                 child: customText(TextUtils.get_started, Colors.white, 15),
        //                 onPressed: () async {
        //                   await LocalPreferences().setBool(
        //                       key: LocalPreferences.intoPageVisitedKey,
        //                       value: true);
        //                   // CustomRoute().clearAndNavigate(
        //                   //   RouteName.home,
        //                   // );
        //                 }),
        //             16.ph,
        //           ],
        //         ),
        //       ) // This trailing comma makes auto-formatting nicer for build methods.
        //           );
        //     },
        //   ),
        // )
        ;
  }
}
