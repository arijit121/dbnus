import 'package:flutter/material.dart';

import '../router/router_manager.dart';

class CurrentContext {
  BuildContext context = RouterManager
      .getInstance.router.routerDelegate.navigatorKey.currentContext!;
}
