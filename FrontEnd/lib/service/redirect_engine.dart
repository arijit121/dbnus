import 'package:flutter/foundation.dart';

import '../const/api_url_const.dart';
import '../router/router_manager.dart';
import '../router/router_name.dart';

class RedirectEngine {
  Future<void> redirectRoutes(
      {required Uri redirectUrl, int delayedSeconds = 0}) async {
    Future.delayed(Duration(seconds: delayedSeconds), () async {
      RouterManager routerManager = RouterManager.getInstance;
      String location =
          redirectUrl.toString().replaceAll(ApiUrlConst.hostUrl, "").trim();

      if (routerManager.router.routeInformationParser.configuration
          .findMatch(Uri(path: redirectUrl.path))
          .matches
          .isNotEmpty) {
        if (kIsWeb) {
          routerManager.router.go(location);
        } else {
          switch (location) {
            case RouteName.games:
              routerManager.router.goNamed(RouteName.games);
              break;
            default:
              routerManager.router.push(location);
              break;
          }
        }
      }
    });
  }
}
