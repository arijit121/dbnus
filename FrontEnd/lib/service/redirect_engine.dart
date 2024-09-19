import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../const/api_url_const.dart';
import '../router/router_manager.dart';

class RedirectEngine {
  Future<void> redirectRoutes(
      {required Uri redirectUrl, int delayedSeconds = 0}) async {
    Future.delayed(Duration(seconds: delayedSeconds), () async {
      RouterManager routerManager = RouterManager.getInstance;
      String location =
          redirectUrl.toString().replaceAll(ApiUrlConst.hostUrl, "");
      if (routerManager.router.routeInformationParser.configuration
          .findMatch(Uri(path: redirectUrl.path))
          .matches
          .isNotEmpty) {
        kIsWeb
            ? routerManager.router.go(location)
            : routerManager.router.push(location);
      }
    });
  }
}
