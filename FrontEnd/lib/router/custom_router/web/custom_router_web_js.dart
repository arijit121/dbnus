import 'package:dbnus/extension/logger_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:universal_html/html.dart' as html;

import '../../../service/context_service.dart';
import '../../router_manager.dart';

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

    html.window.open(url, "_self");
  }

  void reDirect(String url) {
    html.window.location.href = url;
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
    html.window.history.go(-1);
  }

  /// Number of Html Back
  ///
  ///
  void numBack(int index) {
    html.window.history.go(-index);
  }

  /// Html SecBack
  ///
  ///
  void secBack() {
    html.window.history.go(-2);
  }

  bool canBack() {
    try {
      return historyIndex() > 0;
    } catch (e, s) {
      AppLog.e(e, stackTrace: s);
    }
    return false;
  }

  int historyIndex() {
    int index = 0;
    try {
      index = html.window.history.state["serialCount"];
    } catch (e, s) {
      AppLog.e(e, stackTrace: s);
    }
    if (index == 0) {
      index = html.window.history.length - 2;
      if (index <= 0) {
        index = 1;
      }
    }
    return index;
  }
}
