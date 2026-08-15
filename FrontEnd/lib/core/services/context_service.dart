import 'package:dbnus/navigation/router_manager.dart';
import 'package:flutter/widgets.dart';

class CurrentContext {
  BuildContext context = RouterManager
      .getInstance.router.routerDelegate.navigatorKey.currentContext!;
}
