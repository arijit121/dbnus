import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:dbnus/core/network/models/razorpay_merchant_details.dart';
import 'package:dbnus/core/models/route_model.dart';
import 'package:dbnus/shared/extensions/logger_extension.dart';
import 'package:dbnus/features/payment_gateway/module/rayzorpay/ui/rayzorpay.dart'
    deferred as rayzorpay;
import 'package:dbnus/features/payment_gateway/module/web_view_payment_gateway/model/web_view_payment_gateway_model.dart';
import 'package:dbnus/features/payment_gateway/module/web_view_payment_gateway/ui/web_view_payment_gateway.dart'
    deferred as web_view_payment_gateway;
import 'package:dbnus/core/services/JsService/provider/js_provider.dart';
import 'package:dbnus/core/services/context_service.dart';
import 'package:dbnus/core/services/crash/ui/crash_ui.dart'
    deferred as crash_ui;
import 'package:dbnus/shared/ui/molecules/error/error_route_widget.dart'
    deferred as error_route_widget;
import 'package:dbnus/navigation/router_manager.dart';
import 'package:dbnus/navigation/router_name.dart';
import 'package:dbnus/navigation/custom_router/web/custom_router_web.dart';

class CustomRoute {
  /// Manually navigating back always returns `[1]` as the default value in `[App]`,
  /// ensuring a consistent behavior across the application.
  /// If a `result` is provided, it will be used instead of `[1]` on non-web platforms.
  static Future<void> back<T extends Object?>([T? result]) async {
    assert(!kIsWeb || result == null,
        'Passing a result is not allowed on the web.');
    try {
      if (RouterManager.getInstance.routeHistory.isNotEmpty) {
        RouterManager.getInstance.routeHistory.removeLast();
      }
      if (kIsWeb) {
        bool canBack = await CustomRouterWeb().canBack();
        canBack
            ? CustomRouterWeb().back()
            : await clearAndNavigateName(RouteName.initialView);
      } else {
        if (RouterManager.getInstance.router.canPop() == true) {
          RouterManager.getInstance.router.pop(result ?? 1);
        } else {
          await clearAndNavigateName(RouteName.initialView);
        }
      }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
      await clearAndNavigateName(RouteName.initialView);
    }
  }

  static Future<void> secBack() async {
    await back();
    await back();
  }

  static Future<void> clearAndNavigateName(String name,
      {Map<String, String> pathParameters = const <String, String>{},
      Map<String, dynamic> queryParameters = const <String, dynamic>{},
      Object? extra}) async {
    RouterManager.getInstance.routeHistory.clear();
    if (!kIsWeb) {
      RouterManager routerManager = RouterManager.getInstance;
      routerManager.router.goNamed(name,
          queryParameters: queryParameters,
          pathParameters: pathParameters,
          extra: extra);
    } else {
      await JsProvider().clearSessionStorageKey("routeHistory");
      RouterManager routerManager = RouterManager.getInstance;
      routerManager.router.goNamed(name,
          queryParameters: queryParameters,
          pathParameters: pathParameters,
          extra: extra);
    }
  }

  static Future<void> clearAndNavigateGo(String location,
      {Object? extra}) async {
    RouterManager.getInstance.routeHistory.clear();
    if (!kIsWeb) {
      RouterManager routerManager = RouterManager.getInstance;
      routerManager.router.go(location, extra: extra);
    } else {
      await JsProvider().clearSessionStorageKey("routeHistory");
      RouterManager routerManager = RouterManager.getInstance;
      routerManager.router.go(location, extra: extra);
    }
  }

  static Future<MaterialPageRoute> _getRoute(
      {required String name, dynamic arguments}) async {
    switch (name) {
      case RouteName.rayzorPay:
        await Future.wait(
            [rayzorpay.loadLibrary(), error_route_widget.loadLibrary()]);
        return MaterialPageRoute(builder: (_) {
          if (arguments is RazorpayMerchantDetails) {
            return rayzorpay.RayzorPay(razorpayMerchantDetails: arguments);
          } else {
            return error_route_widget.ErrorRouteWidget();
          }
        });
      case RouteName.webViewPaymentGateway:
        await Future.wait([
          web_view_payment_gateway.loadLibrary(),
          error_route_widget.loadLibrary()
        ]);
        return MaterialPageRoute(builder: (_) {
          if (arguments is WebViewPaymentGatewayModel) {
            return web_view_payment_gateway.WebViewPaymentGateway(
                webViewPaymentGatewayModel: arguments);
          } else {
            return error_route_widget.ErrorRouteWidget();
          }
        });
      case RouteName.error:
        await Future.wait(
            [crash_ui.loadLibrary(), error_route_widget.loadLibrary()]);
        return MaterialPageRoute(builder: (_) {
          if (arguments is Map<String, dynamic>) {
            return crash_ui.CrashUi(errorDetails: arguments);
          } else {
            return error_route_widget.ErrorRouteWidget();
          }
        });

      default:
        await error_route_widget.loadLibrary();
        return MaterialPageRoute(
            builder: (_) => error_route_widget.ErrorRouteWidget());
    }
  }

  static Future pushNamed({required String name, dynamic arguments}) async {
    RouterManager.getInstance.routeHistory
        .add(RouteModel(name: name, uri: Uri.parse(name)));
    final route = await CustomRoute._getRoute(name: name, arguments: arguments);
    await Navigator.push(CurrentContext().context, route);
    if (RouterManager.getInstance.routeHistory.isNotEmpty) {
      RouterManager.getInstance.routeHistory.removeLast();
    }
    return;
  }

  static String? currentRoute() {
    try {
      final String location =
          RouterManager.getInstance.routeHistory.last.uri.toString();
      return location;
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  static RouteModel? previousRouteAtIndex({int index = 1}) {
    try {
      return RouterManager.getInstance.routeHistory.length >= (1 + index)
          ? RouterManager.getInstance.routeHistory[
              RouterManager.getInstance.routeHistory.length - (1 + index)]
          : null;
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  static Future<void> navigateNamed(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) async {
    GoRouter router = RouterManager.getInstance.router;
    if (kIsWeb) {
      router.goNamed(name,
          pathParameters: pathParameters,
          queryParameters: queryParameters,
          extra: extra);
    } else {
      await router.pushNamed(name,
          pathParameters: pathParameters,
          queryParameters: queryParameters,
          extra: extra);
    }
  }
}
