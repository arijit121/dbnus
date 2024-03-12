import 'package:flutter/material.dart';
import 'package:genu/extension/logger_extension.dart';

import '../../../utils/screen_utils.dart';
import '../widget/landing_widget.dart';

class LandingUi extends StatefulWidget {
  const LandingUi({super.key});

  @override
  State<LandingUi> createState() => _LandingUiState();
}

class _LandingUiState extends State<LandingUi> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: LandingWidget().drawerNavigationRailWithTitle(
          chooseIndex: (int value) {
        Navigator.of(context).pop();
        AppLog.i(value);
      }),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ScreenUtils.responsiveUI(
            narrowUI: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                }),
            mediumUI: LandingWidget().drawerNavigationRailMediumUI(),
            largeUI: LandingWidget()
                .drawerNavigationRailWithTitle(chooseIndex: (int value) {})),
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
