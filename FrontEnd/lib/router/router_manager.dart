import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../modules/landing/ui/landing.dart' deferred as landing;
import '../modules/landing/utils/landing_utils.dart';
import '../modules/order_details/ui/order_details.dart'
    deferred as order_details;
import '../modules/payment_gateway/module/web_view_payment_gateway/ui/web_view_payment_gateway_status.dart'
    deferred as web_view_payment_gateway_status;
import '../modules/settings/ui/settings.dart' deferred as settings;
import '../service/crash/ui/crash_ui.dart' deferred as crash;
import '../widget/error_route_widget.dart' deferred as error_route_widget;
import 'router_name.dart';

class RouterManager {
  //This creates the single instance by calling the `_internal` constructor specified below
  static final RouterManager _singleton = RouterManager._internal();

  RouterManager._internal();

  //This is what's used to retrieve the instance through the app
  static RouterManager getInstance = _singleton;

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  GoRouter get router => _router;
  final GoRouter _router = GoRouter(
    observers: <NavigatorObserver>[observer],
    routes: <RouteBase>[
      GoRoute(
        name: RouteName.initialView,
        path: RouteName.initialView,
        // builder: (BuildContext context, GoRouterState state) {
        //   return landing.LandingUi(
        //     index: 0,
        //   );
        // },
        pageBuilder: (BuildContext context, GoRouterState state) {
          return slideTransition(
            landing.LandingUi(key: Key("0"), index: 0),
          );
        },
        redirect: (BuildContext context, GoRouterState state) async {
          await landing.loadLibrary();
          return null;
        },
      ),
      GoRoute(
        name: RouteName.leaderBoard,
        path: RouteName.leaderBoard,
        // builder: (BuildContext context, GoRouterState state) {
        //   return landing.LandingUi(
        //     index: LandingUtils.listNavigation.indexWhere(
        //         (element) => element.action == RouteName.leaderBoard),
        //   );
        // },
        pageBuilder: (BuildContext context, GoRouterState state) {
          return slideTransition(
            landing.LandingUi(
              key: Key(
                  "${LandingUtils.listNavigation.indexWhere((element) => element.action == RouteName.leaderBoard)}"),
              index: LandingUtils.listNavigation.indexWhere(
                  (element) => element.action == RouteName.leaderBoard),
            ),
          );
        },
        redirect: (BuildContext context, GoRouterState state) async {
          await landing.loadLibrary();
          return null;
        },
      ),
      GoRoute(
        name: RouteName.order,
        path: RouteName.order,
        // builder: (BuildContext context, GoRouterState state) {
        //   return landing.LandingUi(
        //     index: LandingUtils.listNavigation
        //         .indexWhere((element) => element.action == RouteName.order),
        //   );
        // },
        pageBuilder: (BuildContext context, GoRouterState state) {
          return slideTransition(
            landing.LandingUi(
              key: Key(
                  "${LandingUtils.listNavigation.indexWhere((element) => element.action == RouteName.order)}"),
              index: LandingUtils.listNavigation
                  .indexWhere((element) => element.action == RouteName.order),
            ),
          );
        },
        redirect: (BuildContext context, GoRouterState state) async {
          await landing.loadLibrary();
          return null;
        },
      ),
      GoRoute(
        name: RouteName.games,
        path: RouteName.games,
        // builder: (BuildContext context, GoRouterState state) {
        //   return landing.LandingUi(
        //     index: LandingUtils.listNavigation
        //         .indexWhere((element) => element.action == RouteName.games),
        //   );
        // },
        pageBuilder: (BuildContext context, GoRouterState state) {
          return slideTransition(
            landing.LandingUi(
              key: Key(
                  "${LandingUtils.listNavigation.indexWhere((element) => element.action == RouteName.games)}"),
              index: LandingUtils.listNavigation
                  .indexWhere((element) => element.action == RouteName.games),
            ),
          );
        },
        redirect: (BuildContext context, GoRouterState state) async {
          await landing.loadLibrary();
          return null;
        },
      ),
      GoRoute(
        name: RouteName.massage,
        path: RouteName.massage,
        // builder: (BuildContext context, GoRouterState state) {
        //   return landing.LandingUi(
        //     index: LandingUtils.listNavigation
        //         .indexWhere((element) => element.action == RouteName.massage),
        //   );
        // },
        pageBuilder: (BuildContext context, GoRouterState state) {
          return slideTransition(
            landing.LandingUi(
              key: Key(
                  "${LandingUtils.listNavigation.indexWhere((element) => element.action == RouteName.massage)}"),
              index: LandingUtils.listNavigation
                  .indexWhere((element) => element.action == RouteName.massage),
            ),
          );
        },
        redirect: (BuildContext context, GoRouterState state) async {
          await landing.loadLibrary();
          return null;
        },
      ),
      GoRoute(
        name: RouteName.orderDetails,
        path: "${RouteName.orderDetails}/:order_id",
        builder: (BuildContext context, GoRouterState state) {
          if (state.pathParameters["order_id"]?.isNotEmpty == true) {
            return order_details.OrderDetails(
              orderId: state.pathParameters["order_id"] ?? "",
            );
          } else {
            return error_route_widget.ErrorRouteWidget();
          }
        },
        redirect: (BuildContext context, GoRouterState state) async {
          await order_details.loadLibrary();
          return null;
        },
      ),
      GoRoute(
        name: RouteName.settings,
        path: RouteName.settings,
        builder: (BuildContext context, GoRouterState state) {
          Map<String, String> queryParameters = state.uri.queryParameters;
          return settings.Settings(
            accountSetting: queryParameters["account_setting"] == "true",
          );
        },
        redirect: (BuildContext context, GoRouterState state) async {
          await settings.loadLibrary();
          return null;
        },
      ),
      GoRoute(
        name: RouteName.webViewPaymentStatusWeb,
        path: "${RouteName.webViewPaymentStatusWeb}/:pg_type",
        builder: (BuildContext context, GoRouterState state) {
          if (kIsWeb) {
            return web_view_payment_gateway_status
                .WebViewPaymentGatewayStatus();
          } else {
            return error_route_widget.ErrorRouteWidget();
          }
        },
        redirect: (BuildContext context, GoRouterState state) async {
          await web_view_payment_gateway_status.loadLibrary();
          return null;
        },
      ),
      GoRoute(
        name: RouteName.error,
        path: RouteName.error,
        builder: (BuildContext context, GoRouterState state) {
          if (state.extra is Map<String, dynamic>) {
            return crash.CrashUi(
              errorDetails: state.extra as Map<String, dynamic>,
            );
          } else {
            return error_route_widget.ErrorRouteWidget();
          }
        },
        redirect: (BuildContext context, GoRouterState state) async {
          await crash.loadLibrary();
          return null;
        },
      ),

      // GoRoute(
      //   name: RouteName.bookingReschedule,
      //   path: "${RouteName.bookingReschedule}/:booking_no",
      //   builder: (BuildContext context, GoRouterState state) {
      //     if (state.pathParameters["booking_no"]?.isNotEmpty == true) {
      //       return BookingReschedule(
      //         key: ValueKey(state.pathParameters["booking_no"] ?? ""),
      //         bookingNo: state.pathParameters["booking_no"] ?? "",
      //       );
      //     } else {
      //       return ErrorRouteWidget();
      //     }
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
      //         key: ValueKey("${state.pathParameters["booking_id"] ?? ""}${state.pathParameters["patient_id"] ?? ""}"),
      //         bookingId: state.pathParameters["booking_id"] ?? "",
      //         patientId: state.pathParameters["patient_id"] ?? "",
      //         isPayment: queryParameters["isPayment"] == "true",
      //       );
      //     } else {
      //       return ErrorRouteWidget();
      //     }
      //   },
      // ),
    ],
    errorBuilder: (context, state) => error_route_widget.ErrorRouteWidget(),
    redirect: (BuildContext context, GoRouterState state) async {
      await error_route_widget.loadLibrary();
      return null;
    },
  );

  static CustomTransitionPage<void> slideTransition(Widget screen) {
    return CustomTransitionPage<void>(
      child: screen,
      transitionDuration: const Duration(milliseconds: 800), // Adjust as needed
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        if (kIsWeb) {
          return child; // No transition on web
        }

        const begin = Offset(1.0, 0.0); // Start offscreen (right)
        const end = Offset(0.0, 0.0); // End at the center (screen)
        final tween = Tween(begin: begin, end: end);
        final curveTween =
            CurveTween(curve: Curves.easeOutExpo); // Fast to slow

        return SlideTransition(
          position: tween.animate(CurvedAnimation(
            parent: animation,
            curve: curveTween.curve,
          )),
          child: child,
        );
      },
    );
  }
}
