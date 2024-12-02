import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/model/razorpay_merchant_details.dart';
import '../../extension/logger_extension.dart';
import '../../modules/payment_gateway/module/rayzorpay/ui/rayzorpay.dart';
import '../../service/context_service.dart';
import '../../service/crash/ui/crash_ui.dart';
import '../router_manager.dart';
import '../router_name.dart';
import 'web/custom_router_web.dart';

class CustomRoute {
  /// Manual back always return [1] as value in [App].
  void back() {
    if (kIsWeb) {
      bool canBack = CustomRouterWeb().canBack();
      canBack
          ? CustomRouterWeb().back()
          : clearAndNavigate(RouteName.initialView);
    } else {
      if (RouterManager.getInstance.router.canPop() == true) {
        RouterManager.getInstance.router.pop(1);
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

  MaterialPageRoute _getRoute({required String name, dynamic arguments}) {
    switch (name) {
      case RouteName.rayzorpay:
        return MaterialPageRoute(builder: (_) {
          if (arguments is RazorpayMerchantDetails) {
            return RayzorPay(razorpayMerchantDetails: arguments);
          } else {
            return RouterManager.errorRoute();
          }
        });
      case RouteName.error:
        return MaterialPageRoute(builder: (_) {
          if (arguments is Map<String, dynamic>) {
            return CrashUi(errorDetails: arguments);
          } else {
            return RouterManager.errorRoute();
          }
        });
      default:
        return MaterialPageRoute(builder: (_) {
          return RouterManager.errorRoute();
        });
    }
  }

  Future pushNamed({required String name, dynamic arguments}) {
    return Navigator.push(
        CurrentContext().context, _getRoute(name: name, arguments: arguments));
  }

  String currentRoute() {
    final RouteMatch lastMatch = RouterManager
        .getInstance.router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : RouterManager.getInstance.router.routerDelegate.currentConfiguration;
    final String location = matchList.uri.toString();
    return location;
  }

  void goto({required String routeName}) {
    BuildContext context = CurrentContext().context;
    if (kIsWeb) {
      context.goNamed(routeName);
    } else {
      context.pushNamed(routeName);
    }
  }
}
