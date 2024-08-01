import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../../extension/logger_extension.dart';
import '../../service/JsService/provider/js_provider.dart';
import '../../service/context_service.dart';
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
      final List<RouteMatchBase> lastMatch =
          routerManager.router.routerDelegate.currentConfiguration.matches;
      for (int index = 0; index < lastMatch.length - 1; index++) {
        routerManager.router.pop();
      }
      routerManager.router.pushReplacementNamed(name,
          queryParameters: queryParameters,
          pathParameters: pathParameters,
          extra: extra);
    } else {
      RouterManager routerManager = RouterManager.getInstance;
      RouteBase routeBase = routerManager.router.configuration.routes
          .firstWhere((element) => element.toString().contains(name),
              orElse: () {
        return routerManager.router.configuration.routes.first;
      });
      // GoRoute#dda94(name: "/return_order", path: "/return_order/:orderID/:invoiceID")
      // [GoRoute#e5eb9(name: "/return_order",  path: "/return_order/:orderID/:invoiceID")]
      List<String> res = routeBase.toString().split(",");
      String res2 = res.last.replaceAll(")", "");
      String res3 = res2.replaceAll("path:", "").trim();
      String res4 = res3.replaceAll('"', "").trim();

      String url = res4;

      if (queryParameters.isNotEmpty) {
        url = Uri.parse(name)
            .replace(queryParameters: queryParameters)
            .toString();
      }

      if (pathParameters.isNotEmpty && res3.contains("/:")) {
        String temp = url;

        List<String> keyList = pathParameters.keys.toList();
        List<String> valueList = pathParameters.values.toList();
        url = Uri.parse(temp.replaceAll(
                "/:${keyList.join("/:")}", "/${valueList.join("/")}"))
            .toString();
      }
      if (CustomRouterWeb().historyIndex() != 0) {
        CustomRouterWeb().numBack(CustomRouterWeb().historyIndex());
      }
      Future.delayed(
          Duration(milliseconds: CustomRouterWeb().historyIndex() * 10), () {
        CustomRouterWeb().goToNameAndOff(name,
            queryParameters: queryParameters,
            pathParameters: pathParameters,
            extra: extra);
      });
    }
  }

  MaterialPageRoute getRoute({required String name, dynamic arguments}) {
    switch (name) {
      // case RouteName.cartUploadPrescription:
      //   return MaterialPageRoute(builder: (_) {
      //     if (arguments is Map) {
      //       return PhonePeWebViewScreen(phonePeDetails: arguments);
      //     }
      //     return RouterManager.errorRoute();
      //   });
      default:
        return MaterialPageRoute(builder: (_) {
          return RouterManager.errorRoute();
        });
    }
  }

  Future pushNamed({required String name, dynamic arguments}) {
    return Navigator.push(
        CurrentContext().context, getRoute(name: name, arguments: arguments));
  }

  String currentRoute() {
    final RouteMatch lastMatch = RouterManager
        .getInstance.router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : RouterManager.getInstance.router.routerDelegate.currentConfiguration;
    final String location = matchList.uri.toString();
    AppLog.i(location, tag: "CurrentRoute");
    return location;
  }
}
