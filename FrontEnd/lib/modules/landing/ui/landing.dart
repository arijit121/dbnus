import 'package:dbnus/data/model/forward_geocoding.dart';
import 'package:dbnus/extension/spacing.dart';
import 'package:dbnus/service/download_handler.dart';
import 'package:dbnus/widget/custom_text.dart';
import 'package:dbnus/widget/custom_text_formfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/reverse_geocoding.dart';
import '../../../extension/logger_extension.dart';
import '../../../router/custom_router/custom_route.dart';
import '../../../service/geocoding.dart';
import '../../../service/open_service.dart';
import '../../../utils/screen_utils.dart';
import '../../../widget/custom_button.dart';
import '../../../widget/custom_dropdown.dart';
import '../../reorderable_list/ui/my_reorderable_list.dart';
import '../bloc/landing_bloc.dart';
import '../utils/landing_utils.dart';
import '../widget/landing_widget.dart';

// ignore: must_be_immutable
class LandingUi extends StatefulWidget {
  LandingUi({super.key, required this.index});

  int index;

  @override
  State<LandingUi> createState() => _LandingUiState();
}

class _LandingUiState extends State<LandingUi> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _narrowUiBody() => Column(
        children: [
          Row(
            children: [
              CustomIconButton(
                  color: Colors.black,
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  }),
            ],
          ),
          Expanded(
            child: ListView(
              primary: false,
              children: [
                20.ph,
                CustomIconButton(icon: const Icon(Icons.abc), onPressed: () {}),
                20.ph,
                CustomGOEButton(
                  child: const CustomText("text"),
                  onPressed: () {},
                ),
                20.ph,
                CustomGOEButton(
                    onPressed: () {},
                    gradient: const LinearGradient(colors: [
                      Colors.red,
                      Colors.blue,
                    ]),
                    child: const CustomText("text")),
                20.ph,
                CustomGOEButton(
                  onPressed: () {},
                  child: const CustomText("text"),
                ),
                20.ph,
                CustomTextButton(
                    child: const CustomText("text"), onPressed: () {}),
                20.ph,
                const CustomText("text"),
                20.ph,
                CustomGOEButton(
                    onPressed: () {
                      DownloadHandler().download(
                          url:
                              "https://res.genupathlabs.com/genu_path_lab/live/customer_V2/sample_report/GlucoseFasting.pdf");
                    },
                    gradient: const LinearGradient(colors: [
                      Colors.red,
                      Colors.blue,
                    ]),
                    child: const CustomText("GlucoseFasting")),
                20.ph,
                CustomGOEButton(
                    onPressed: () {
                      DownloadHandler().download(
                          url:
                              "https://res.genupathlabs.com/genu_path_lab/live/customer_V2/sample_report/GlucosePP.pdf");
                    },
                    gradient: const LinearGradient(colors: [
                      Colors.red,
                      Colors.blue,
                    ]),
                    child: const CustomText("GlucosePP")),
                20.ph,
                CustomGOEButton(
                    onPressed: () {
                      DownloadHandler().download(
                          url:
                              "https://res.genupathlabs.com/genu_path_lab/live/customer_V2/sample_report/LipidProfile.pdf");
                    },
                    gradient: const LinearGradient(colors: [
                      Colors.red,
                      Colors.blue,
                    ]),
                    child: const CustomText("LipidProfile")),
                20.ph,
                CustomGOEButton(
                    onPressed: () {
                      DownloadHandler().download(
                          url:
                              "https://storage.googleapis.com/approachcharts/test/5MB-test.ZIP");
                    },
                    gradient: const LinearGradient(colors: [
                      Colors.red,
                      Colors.blue,
                    ]),
                    child: const CustomText("5MB-test")),
                20.ph,
                CustomGOEButton(
                    onPressed: () async {
                      ForwardGeocoding? forwardGeocoding = await Geocoding()
                          .forwardGeocoding(
                              address:
                                  "Jot Bhim, New Town, Bidhannagar, North 24 Parganas District, West Bengal, 700160, India");
                      AppLog.i(forwardGeocoding?.longitude);
                    },
                    gradient: const LinearGradient(colors: [
                      Colors.red,
                      Colors.blue,
                    ]),
                    child: const CustomText(
                        "Jot Bhim, New Town, Bidhannagar, North 24 Parganas District, West Bengal, 700160, India")),
                20.ph,
                CustomGOEButton(
                    onPressed: () async {
                      ReverseGeocoding? reverseGeocoding = await Geocoding()
                          .reverseGeocoding(
                              latitude: 22.5754, longitude: 88.4798);
                      AppLog.i(reverseGeocoding?.displayName);
                    },
                    gradient: const LinearGradient(colors: [
                      Colors.red,
                      Colors.blue,
                    ]),
                    child: const CustomText(
                        "Reverse Geocoding latitude: 22.5754, longitude: 88.4798")),
                20.ph,
              ],
            ),
          ),
        ],
      );

  Widget _mediumUiBody({required LandingState state}) =>
      SizedBox(width: ScreenUtils.aw() - 120, child: MyReorderableList());

  Widget _largeUiBody({required LandingState state}) => Flexible(
        child: Column(
          children: [
            CustomGOEButton(
              child: const CustomText("text"),
              onPressed: () {},
            ),
            20.ph,
            CustomGOEButton(
                onPressed: () {
                  DownloadHandler().download(
                      url:
                          "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf");
                },
                gradient: const LinearGradient(colors: [
                  Colors.red,
                  Colors.blue,
                ]),
                child: const CustomText("Download")),
            const CustomTextFormField(),
            CustomDropdownMenuFormField<String>(
                hintText: "Please choose val",
                suffix: const Icon(Icons.keyboard_arrow_down_rounded),
                onChanged: (value) {
                  AppLog.d(value);
                },
                items: List.generate(
                    10,
                    (index) => CustomDropDownModel<String>(
                        value: "test$index", title: "test$index"))),
            CustomMenuAnchor<String>(
              // hintText: "Please choose val",
              // suffix: const Icon(Icons.keyboard_arrow_down_rounded),
              onPressed: (value) {
                AppLog.d(value);
              },
              items: List.generate(
                  10,
                  (index) => CustomDropDownModel<String>(
                      value: "test$index", title: "test$index")),
              child: const Icon(
                Icons.zoom_out_rounded,
                color: Colors.amber,
              ),
            ),
            CustomIconButton(
                color: Colors.black,
                icon: Icon(Icons.map),
                onPressed: () {
                  OpenService()
                      .openAddressInMap(address: 'Kolkata', direction: true);
                }),
            CustomIconButton(
                color: Colors.black,
                icon: Icon(Icons.map),
                onPressed: () {
                  OpenService().openCoordinatesInMap(
                    latitude: 22.5354273,
                    longitude: 88.3473527,
                  );
                }),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LandingBloc()..add(ChangeIndex(index: widget.index)),
      child: BlocBuilder<LandingBloc, LandingState>(
        builder: (context, state) {
          return Scaffold(
            appBar: state.pageIndex.value != 0
                ? AppBar(
                    leading: CustomIconButton(
                        onPressed: () {
                          CustomRoute().back();
                        },
                        icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                  )
                : null,
            key: _scaffoldKey,
            drawer: SafeArea(
              child: LandingWidget().drawerNavigationRail(
                  selectedIndex: state.pageIndex.value,
                  withTitle: true,
                  chooseIndex: (int value) {
                    Navigator.of(context).pop();
                    if (value == 6) {
                      AppLog.i("Log out");
                    } else if (kIsWeb) {
                      LandingUtils.redirect(value);
                    } else {
                      context
                          .read<LandingBloc>()
                          .add(ChangeIndex(index: value));
                    }
                  }),
            ),
            backgroundColor: Colors.white,
            body: SafeArea(
                child: ResponsiveUI(
              narrowUI: (BuildContext context) {
                return _narrowUiBody();
              },
              mediumUI: (BuildContext context) {
                return Row(
                  children: [
                    LandingWidget().drawerNavigationRail(
                        selectedIndex: state.pageIndex.value,
                        chooseIndex: (int value) {
                          if (value == 6) {
                            AppLog.i("Log out");
                          } else if (kIsWeb) {
                            LandingUtils.redirect(value);
                          } else {
                            context
                                .read<LandingBloc>()
                                .add(ChangeIndex(index: value));
                          }
                        }),
                    _mediumUiBody(state: state),
                  ],
                );
              },
              largeUI: (BuildContext context) {
                return Row(
                  children: [
                    LandingWidget().drawerNavigationRail(
                        selectedIndex: state.pageIndex.value,
                        withTitle: true,
                        chooseIndex: (int value) {
                          if (value == 6) {
                            AppLog.i("Log out");
                          } else if (kIsWeb) {
                            LandingUtils.redirect(value);
                          } else {
                            context
                                .read<LandingBloc>()
                                .add(ChangeIndex(index: value));
                          }
                        }),
                    _largeUiBody(state: state),
                  ],
                );
              },
            )),
          );
        },
      ),
    );
  }
}
