import 'dart:convert';

import 'package:dbnus/shared/extensions/logger_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:web/web.dart' as web;

import 'package:dbnus/core/services/JsService/provider/js_provider.dart';
import 'package:dbnus/core/services/context_service.dart';
import 'package:dbnus/core/services/value_handler.dart';
import 'package:dbnus/navigation/router_manager.dart';

class CustomRouterWeb {
  /// open the Page in same tab
  ///
  ///
  void openPageSameTab(
    String name, {
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
  }) {
    String url = name;

    if (queryParameters != null && queryParameters.isNotEmpty) {
      url =
          Uri.parse(name).replace(queryParameters: queryParameters).toString();
    }

    if (pathParameters != null && pathParameters.isNotEmpty) {
      List<GoRoute> goRouteList = RouterManager
          .getInstance.router.configuration.routes
          .map((e) => e as GoRoute)
          .toList();
      GoRoute goRoute = goRouteList.firstWhere(
          (element) => element.name == name,
          orElse: () => GoRoute(path: name));
      String temp = goRoute.path;
      List<String> keyList = pathParameters.keys.toList();
      List<String> valueList = pathParameters.values.toList();
      url = Uri.parse(temp.replaceAll(
              "/:${keyList.join("/:")}", "/${valueList.join("/")}"))
          .toString();
    }

    web.window.open(url, "_self");
  }

  void reDirect(String url) {
    web.window.location.href = url;
  }

  /// Pop and remove the state from stack
  ///
  ///
  void popAndOff([dynamic result]) {
    Router.neglect(CurrentContext().context, () {
      CurrentContext().context.pop(result);
    });
  }

  /// Html Back
  ///
  ///
  void back() {
    web.window.history.go(-1);
  }

  /// Number of Html Back
  ///
  ///
  void numBack(int index) {
    web.window.history.go(-index);
  }

  /// Html SecBack
  ///
  ///
  void secBack() {
    web.window.history.go(-2);
  }

  Future<bool> canBack() async {
    try {
      return await historyIndex() > 0;
    } catch (e, s) {
      AppLog.e(e, stackTrace: s);
    }
    return false;
  }

  Future<int> historyIndex() async {
    int index = 0;
    try {
      String? routeHistory =
          await JsProvider().getSessionStorageItem("routeHistory");
      if (ValueHandler.isTextNotEmptyOrNull(routeHistory)) {
        String value = json.decode(routeHistory!);
        value.replaceAll("[", "");
        value.replaceAll("]", "");
        value.trim();
        index = (value.split(",")).length - 1;
        if (index <= 0) {
          index = 0;
        }
      }
    } catch (e, s) {
      AppLog.e(e, stackTrace: s);
    }
    return index;
  }
}
