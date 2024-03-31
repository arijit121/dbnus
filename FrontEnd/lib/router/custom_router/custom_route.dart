import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../../data/model/custom_file.dart';
import '../../data/model/paytm_merchant_details.dart';

import '../../extension/logger_extension.dart';
import '../../service/context_service.dart';
import '../router_manager.dart';
import '../router_name.dart';
import 'web/custom_router_web.dart';

class CustomRoute {
  void back() {
    if (kIsWeb) {
      if (RouterManager.getInstance.router.canPop() == true) {
        RouterManager.getInstance.router.pop();
      } else {
        CustomRouterWeb().back();
      }
    } else {
      if (RouterManager.getInstance.router.canPop() == true) {
        RouterManager.getInstance.router.pop();
      } else {
        clearAndNavigate(RouteName.initialView);
      }
    }
  }

  void secBack() {
    if (kIsWeb) {
      CustomRouterWeb().secBack();
    } else {
      RouterManager.getInstance.router.pop();
      RouterManager.getInstance.router.pop();
    }
  }

  void clearAndNavigate(String path) {
    RouterManager routerManager = RouterManager.getInstance;
    if (!kIsWeb) {
      while (routerManager.router.canPop() == true) {
        routerManager.router.pop();
      }
      routerManager.router.pushReplacement(path);
    } else {
      routerManager.router.goNamed(path);
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
