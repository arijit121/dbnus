import 'package:flutter/foundation.dart';

import 'package:dbnus/shared/constants/api_url_const.dart';
import 'package:dbnus/shared/extensions/logger_extension.dart';
import 'package:dbnus/navigation/custom_router/custom_route.dart';
import 'package:dbnus/navigation/router_manager.dart';
import 'package:dbnus/navigation/router_name.dart';
import 'package:dbnus/core/services/value_handler.dart';

class RedirectEngine {
  static Future<bool?> redirectRoutes(
      {required Uri redirectUrl, int delayedSeconds = 0}) async {
    bool canRedirect = false;
    try {
      await Future.delayed(Duration(seconds: delayedSeconds), () async {
        RouterManager routerManager = RouterManager.getInstance;
        String location =
            redirectUrl.toString().replaceAll(ApiUrlConst.hostUrl, "").trim();
        String? currentRoute = CustomRoute.currentRoute()
            ?.replaceAll(ApiUrlConst.hostUrl, "")
            .trim();
        if (routerManager.router.routeInformationParser.configuration
                .findMatch(Uri(path: redirectUrl.path))
                .matches
                .isNotEmpty &&
            location != currentRoute) {
          canRedirect = true;
          if (kIsWeb) {
            routerManager.router.go(location);
          } else {
            switch (location) {
              case RouteName.initialView:
                routerManager.router.goNamed(location);
                break;
              case RouteName.leaderBoard:
                routerManager.router.goNamed(location);
                break;
              case RouteName.order:
                routerManager.router.goNamed(location);
                break;
              case RouteName.games:
                routerManager.router.goNamed(location);
                break;
              default:
                ValueHandler.isTextNotEmptyOrNull(currentRoute)
                    ? routerManager.router.push(location)
                    : routerManager.router.go(location);
                break;
            }
          }
        }
      });
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return canRedirect;
  }
}
