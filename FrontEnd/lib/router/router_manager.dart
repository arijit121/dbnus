import 'package:dbnus/extension/spacing.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:universal_html/html.dart' as html;

import '../const/assects_const.dart';
import '../const/color_const.dart';
import '../modules/landing/ui/landing.dart' deferred as landing;
import '../modules/landing/utils/landing_utils.dart';
import '../modules/order_details/ui/order_details.dart'
    deferred as order_details;
import '../modules/settings/ui/settings.dart' deferred as settings;
import '../service/crash/ui/crash_ui.dart' deferred as crash;
import '../utils/text_utils.dart';
import '../widget/custom_button.dart';
import '../widget/custom_image.dart';
import '../widget/custom_text.dart';
import 'custom_router/custom_route.dart';
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
    observers: <NavigatorObserver>[observer, if (kIsWeb) SeoObserver()],
    redirectLimit: 30,
    routes: <RouteBase>[
      GoRoute(
        name: RouteName.initialView,
        path: RouteName.initialView,
        builder: (BuildContext context, GoRouterState state) {
          return landing.LandingUi(
            index: 0,
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
        builder: (BuildContext context, GoRouterState state) {
          return landing.LandingUi(
            index: LandingUtils.listNavigation.indexWhere(
                (element) => element.action == RouteName.leaderBoard),
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
        builder: (BuildContext context, GoRouterState state) {
          return landing.LandingUi(
            index: LandingUtils.listNavigation
                .indexWhere((element) => element.action == RouteName.order),
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
        builder: (BuildContext context, GoRouterState state) {
          return landing.LandingUi(
            index: LandingUtils.listNavigation
                .indexWhere((element) => element.action == RouteName.games),
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
        builder: (BuildContext context, GoRouterState state) {
          return landing.LandingUi(
            index: LandingUtils.listNavigation
                .indexWhere((element) => element.action == RouteName.massage),
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
            return errorRoute();
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
        name: RouteName.error,
        path: RouteName.error,
        builder: (BuildContext context, GoRouterState state) {
          if (state.extra is Map<String, dynamic>) {
            return crash.CrashUi(
              errorDetails: state.extra as Map<String, dynamic>,
            );
          } else {
            return errorRoute();
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
      //       return errorRoute();
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
      //       return errorRoute();
      //     }
      //   },
      // ),
    ],
    errorBuilder: (context, state) => errorRoute(),
  );

  static Scaffold errorRoute() {
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
              CustomAssetImageView(
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
                  CustomRoute().clearAndNavigate(RouteName.initialView);
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

class SeoObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _updateCanonicalLink();
    if (route.settings.name == RouteName.initialView) {
      _homeHooterSeo();
    } else {
      _removeFooterSeoContainer();
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    _updateCanonicalLink();
    if (previousRoute?.settings.name == RouteName.initialView) {
      _homeHooterSeo();
    } else {
      _removeFooterSeoContainer();
    }
  }

  void _updateCanonicalLink() {
    _setCanonicalLink(html.window.location.href);
  }

  void _setCanonicalLink(String url) {
    final head = html.document.head;
    final existingLink = head?.querySelector('link[rel="canonical"]');

    if (existingLink != null) {
      existingLink.attributes['href'] = url;
    } else {
      final canonicalLink = html.Element.tag('link');
      canonicalLink.setAttribute('rel', 'canonical');
      canonicalLink.setAttribute('href', url);
      head?.append(canonicalLink);
    }
  }

  void _homeHooterSeo() {
    final document = html.document;
    final seoContainer = html.DivElement()..className = 'footerSeoCon';
    seoContainer.setInnerHtml(TextUtils.footer_msg_web,
        validator: html.NodeValidatorBuilder.common());
    if (document.querySelector('.footerSeoCon') == null) {
      document.body?.append(seoContainer);
    }
  }

  void _removeFooterSeoContainer() {
    final element = html.document.querySelector('.footerSeoCon');
    if (element != null) {
      element.remove();
    }
  }
}
