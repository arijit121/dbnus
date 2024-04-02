import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../const/api_url_const.dart';
import '../router/router_manager.dart';

class RedirectEngine {
  Future<void> redirectRoutes(
      {required Uri redirectUrl, int delayedSeconds = 0}) async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Future.delayed(Duration(seconds: delayedSeconds), () async {
        RouterManager routerManager = RouterManager.getInstance;
        String fragment =
            redirectUrl.toString().replaceAll(ApiUrlConst.hostUrl, "");
        if (routerManager.router.routeInformationParser.configuration
            .findMatch(fragment)
            .matches
            .isNotEmpty) {
          kIsWeb
              ? routerManager.router.go(fragment)
              : routerManager.router.push(fragment);
        }
      });
    });
  }
}
