
import 'package:flutter/material.dart';

import 'package:genu/utils/text_utils.dart';
import 'package:genu/widget/error_widget.dart';
import 'package:go_router/go_router.dart';

import '../const/color_const.dart';
import '../extension/hex_color.dart';

import '../modules/landing/ui/landing.dart';

import '../widget/custom_text.dart';
import 'custom_router/custom_route.dart';
import 'router_name.dart';

class RouterManager {
  //This creates the single instance by calling the `_internal` constructor specified below
  static final RouterManager _singleton = RouterManager._internal();

  RouterManager._internal();

  //This is what's used to retrieve the instance through the app
  static RouterManager getInstance = _singleton;

  GoRouter get router => _router;
  final GoRouter _router = GoRouter(
    redirectLimit: 30,
    routes: <RouteBase>[
      GoRoute(
        name: RouteName.initialView,
        path: RouteName.initialView,
        builder: (BuildContext context, GoRouterState state) {
          return  const LandingUi();
        },
      ),
       
      // GoRoute(
      //   name: RouteName.bookingReschedule,
      //   path: "${RouteName.bookingReschedule}/:booking_no",
      //   builder: (BuildContext context, GoRouterState state) {
      //     if (state.pathParameters["booking_no"]?.isNotEmpty == true) {
      //       return BookingReschedule(
      //         bookingNo: state.pathParameters["booking_no"] ?? "",
      //       );
      //     }
      //     return errorRoute();
      //   },
      // ),
      // GoRoute(
      //   name: RouteName.consultationSuccess,
      //   path: RouteName.consultationSuccess,
      //   builder: (BuildContext context, GoRouterState state) {
      //     if (state.extra != null && state.extra is FreeFollowUpResponse) {
      //       return FreeFollowUpSuccess(
      //         freeFollowUpResponse: state.extra as FreeFollowUpResponse,
      //       );
      //     } else {
      //       return FreeFollowUpSuccess();
      //     }
      //   },
      // ),
      // GoRoute(
      //   name: RouteName.consultationPatientInfo,
      //   path: "${RouteName.consultationPatientInfo}/:booking_id/:patient_id",
      //   builder: (BuildContext context, GoRouterState state) {
      //     Map<String, String> queryParameters = state.uri.queryParameters;
      //     if (state.pathParameters["booking_id"]?.isNotEmpty == true &&
      //         state.pathParameters["patient_id"]?.isNotEmpty == true) {
      //       return ConsultationPatientInfo(
      //         bookingId: state.pathParameters["booking_id"] ?? "",
      //         patientId: state.pathParameters["patient_id"] ?? "",
      //         isPayment: queryParameters["isPayment"] == "true",
      //       );
      //     } else {
      //       return errorRoute();
      //     }
      //   },
      // ),
    
    ],
  );

  static Scaffold errorRoute() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: getInstance.router.canPop()
            ? IconButton(
                color: HexColor.fromHex(ColorConst.primaryDark),
                iconSize: 30,
                onPressed: () {
                  CustomRoute().back();
                },
                icon: const Icon(Icons.clear))
            : Container(),
        title: customText(
            TextUtils.notFound,color:  HexColor.fromHex(ColorConst.primaryDark),size:  20),
      ),
      body: Center(
        child: CustomErrorWidget(),
      ),
    );
  }
}
