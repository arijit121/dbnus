import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/model/razorpay_merchant_details.dart';
import '../../extension/logger_extension.dart';
import '../../modules/payment_gateway/module/rayzorpay/ui/rayzorpay.dart'
deferred as rayzorpay;
import '../../service/crash/ui/crash_ui.dart' deferred as crash_ui;
import '../../service/context_service.dart';
import '../../widget/error_route_widget.dart';
import '../router_manager.dart';
import '../router_name.dart';
import 'web/custom_router_web.dart';

class CustomRoute {
  /// Manually navigating back always returns `[1]` as the default value in `[App]`,
  /// ensuring a consistent behavior across the application.
  /// If a `result` is provided, it will be used instead of `[1]` on non-web platforms.
  void back<T extends Object?>([T? result]) {
    assert(!kIsWeb || result == null,
        'Passing a result is not allowed on the web.');

    if (kIsWeb) {
      bool canBack = CustomRouterWeb().canBack();
      canBack
          ? CustomRouterWeb().back()
          : clearAndNavigate(RouteName.initialView);
    } else {
      if (RouterManager.getInstance.router.canPop() == true) {
        RouterManager.getInstance.router.pop(result ?? 1);
      } else {
        clearAndNavigate(RouteName.initialView);
      }
    }
  }

  void secBack() {
    back();
    back();
  }

  void clearAndNavigate(String name,
      {Map<String, String> pathParameters = const <String, String>{},
      Map<String, dynamic> queryParameters = const <String, dynamic>{},
      Object? extra}) {
    if (!kIsWeb) {
      RouterManager routerManager = RouterManager.getInstance;
      routerManager.router.goNamed(name,
          queryParameters: queryParameters,
          pathParameters: pathParameters,
          extra: extra);
    } else {
      RouterManager routerManager = RouterManager.getInstance;
      if (CustomRouterWeb().historyIndex() != 0) {
        CustomRouterWeb().numBack(CustomRouterWeb().historyIndex());
      }
      Future.delayed(
          Duration(milliseconds: CustomRouterWeb().historyIndex() * 10), () {
        routerManager.router.replaceNamed(name,
            queryParameters: queryParameters,
            pathParameters: pathParameters,
            extra: extra);
      });
    }
  }

  Future<MaterialPageRoute> _getRoute(
      {required String name, dynamic arguments}) async {
    switch (name) {
      case RouteName.rayzorpay:
        await rayzorpay.loadLibrary();
        return MaterialPageRoute(builder: (_) {
          if (arguments is RazorpayMerchantDetails) {
            return rayzorpay.RayzorPay(razorpayMerchantDetails: arguments);
          } else {
            return ErrorRouteWidget();
          }
        });

      case RouteName.error:
        await crash_ui.loadLibrary();
        return MaterialPageRoute(builder: (_) {
          if (arguments is Map<String, dynamic>) {
            return crash_ui.CrashUi(errorDetails: arguments);
          } else {
            return ErrorRouteWidget();
          }
        });

      default:
        return MaterialPageRoute(builder: (_) => ErrorRouteWidget());
    }
  }

  Future<void> pushNamed({required String name, dynamic arguments}) async {
    final route = await _getRoute(name: name, arguments: arguments);
    await Navigator.push(CurrentContext().context, route);
  }

  String? currentRoute() {
    try {
      final RouteMatch lastMatch = RouterManager
          .getInstance.router.routerDelegate.currentConfiguration.last;
      final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
          ? lastMatch.matches
          : RouterManager
          .getInstance.router.routerDelegate.currentConfiguration;
      final String location = matchList.uri.toString();
      return location;
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  Future<void> navigateNamed(String name, {
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
