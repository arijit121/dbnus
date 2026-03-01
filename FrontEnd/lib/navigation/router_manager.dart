import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:dbnus/core/models/route_model.dart';
import 'package:dbnus/features/bio_data/presentation/pages/bio_data.dart'
    deferred as flutter_bio_data;
import 'package:dbnus/features/landing/presentation/pages/landing.dart'
    deferred as landing;
import 'package:dbnus/features/landing/presentation/utils/landing_utils.dart';
import 'package:dbnus/features/order_details/presentation/pages/order_details.dart'
    deferred as order_details;
import 'package:dbnus/features/payment_gateway/presentation/pages/web_view_payment_gateway_status/web_view_payment_gateway_status.dart'
    deferred as web_view_payment_gateway_status;
import 'package:dbnus/features/settings/presentation/pages/settings.dart'
    deferred as settings;
import 'package:dbnus/features/flame_game/presentation/pages/tic_tac_toe_game.dart'
    deferred as tic_tac_toe;
import 'package:dbnus/features/flame_game/presentation/pages/color_match_game.dart'
    deferred as color_match;
import 'package:dbnus/features/flame_game/presentation/pages/snake_game.dart'
    deferred as snake_game;
import 'package:dbnus/features/flame_game/presentation/pages/reaction_time_game.dart'
    deferred as reaction_time;
import 'package:dbnus/features/flame_game/presentation/pages/space_shooter_game.dart'
    deferred as space_shooter;
import 'package:dbnus/features/flame_game/presentation/pages/brick_breaker_game.dart'
    deferred as brick_breaker;
import 'package:dbnus/core/services/crash/ui/crash_ui.dart' deferred as crash;
import 'package:dbnus/core/services/value_handler.dart';
import 'package:dbnus/shared/ui/molecules/error/error_route_widget.dart'
    deferred as error_route_widget;
import 'package:dbnus/navigation/router_name.dart';

class RouterManager {
  //This creates the single instance by calling the `_internal` constructor specified below
  static final RouterManager _singleton = RouterManager._internal();

  RouterManager._internal();

  //This is what's used to retrieve the instance through the app
  static RouterManager getInstance = _singleton;

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  List<RouteModel> routeHistory = [];
  int maxHistorySize = 20;

  /// Add route to history
  void _addRoute(GoRouterState route) {
    RouteModel data = RouteModel(
        name: route.name,
        path: route.path,
        uri: route.uri,
        pathParameters: route.pathParameters,
        queryParameters: route.uri.queryParameters,
        extra: route.extra);
    // Avoid duplicates if the same route is pushed consecutively
    if ((routeHistory.isEmpty || routeHistory.last.uri != data.uri) &&
        ValueHandler.isTextNotEmptyOrNull(data.uri)) {
      routeHistory.add(data);

      // Maintain max history size
      if (routeHistory.length > maxHistorySize) {
        routeHistory.removeAt(0);
      }
    }
  }

  GoRouter get router => _router;
  final GoRouter _router = GoRouter(
    observers: <NavigatorObserver>[observer, if (kIsWeb) RouteObserver()],
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
          return _slideTransition(
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
          return _slideTransition(
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
          return _slideTransition(
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
          return _slideTransition(
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
          return _slideTransition(
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
        name: RouteName.bioData,
        path: RouteName.bioData,
        builder: (BuildContext context, GoRouterState state) {
          return flutter_bio_data.BioData();
        },
        redirect: (BuildContext context, GoRouterState state) async {
          await flutter_bio_data.loadLibrary();
          return null;
        },
      ),
      GoRoute(
        name: RouteName.ticTacToe,
        path: RouteName.ticTacToe,
        builder: (BuildContext context, GoRouterState state) {
          return tic_tac_toe.TicTacToePage();
        },
        redirect: (BuildContext context, GoRouterState state) async {
          await tic_tac_toe.loadLibrary();
          return null;
        },
      ),
      GoRoute(
        name: RouteName.colorMatch,
        path: RouteName.colorMatch,
        builder: (BuildContext context, GoRouterState state) {
          return color_match.ColorMatchPage();
        },
        redirect: (BuildContext context, GoRouterState state) async {
          await color_match.loadLibrary();
          return null;
        },
      ),
      GoRoute(
        name: RouteName.snakeGame,
        path: RouteName.snakeGame,
        builder: (BuildContext context, GoRouterState state) {
          return snake_game.SnakeGamePage();
        },
        redirect: (BuildContext context, GoRouterState state) async {
          await snake_game.loadLibrary();
          return null;
        },
      ),
      GoRoute(
        name: RouteName.reactionTime,
        path: RouteName.reactionTime,
        builder: (BuildContext context, GoRouterState state) {
          return reaction_time.ReactionTimePage();
        },
        redirect: (BuildContext context, GoRouterState state) async {
          await reaction_time.loadLibrary();
          return null;
        },
      ),
      GoRoute(
        name: RouteName.spaceShooter,
        path: RouteName.spaceShooter,
        builder: (BuildContext context, GoRouterState state) {
          return space_shooter.SpaceShooterPage();
        },
        redirect: (BuildContext context, GoRouterState state) async {
          await space_shooter.loadLibrary();
          return null;
        },
      ),
      GoRoute(
        name: RouteName.brickBreaker,
        path: RouteName.brickBreaker,
        builder: (BuildContext context, GoRouterState state) {
          return brick_breaker.BrickBreakerPage();
        },
        redirect: (BuildContext context, GoRouterState state) async {
          await brick_breaker.loadLibrary();
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
      getInstance._addRoute(state);
      await error_route_widget.loadLibrary();
      return null;
    },
  );

  static CustomTransitionPage<void> _slideTransition(Widget screen) {
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

  static CustomTransitionPage<void> _fadeTransition(Widget screen) {
    return CustomTransitionPage<void>(
        child: screen,
        transitionDuration: const Duration(milliseconds: 200),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          if (kIsWeb) {
            return child; // No transition on web
          }
          return FadeTransition(
            opacity: CurveTween(curve: Curves.easeIn).animate(animation),
            child: child,
          );
        });
  }
}

class RouteObserver extends NavigatorObserver {
  Future<void> _sendScreenView(PageRoute<dynamic> route) async {
    var screenName = route.settings.name;
    if (screenName != null) {
      // your code goes here
    }
  }

  Future<void> _seoObserver(PageRoute<dynamic> route) async {
    // await web_meta_handler.loadLibrary();
    // web_meta_handler.WebSeoHandler.setCanonicalLink(html.window.location.href);
    // if (route.settings.name == RouteName.initialView) {
    //   web_meta_handler.WebSeoHandler.homeFooterSeo();
    // } else {
    //   web_meta_handler.WebSeoHandler.removeFooterSeoContainer();
    // }
  }

  /// Remove the last route from history
  void _removeLastRoute() {
    if (RouterManager.getInstance.routeHistory.isNotEmpty) {
      RouterManager.getInstance.routeHistory.removeLast();
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      _sendScreenView(route);
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      _sendScreenView(previousRoute);
    }
    _removeLastRoute();
  }
}
