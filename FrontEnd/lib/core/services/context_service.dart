import 'package:material_ui/material_ui.dart';

import 'package:dbnus/navigation/router_manager.dart';

class CurrentContext {
  BuildContext context = RouterManager
      .getInstance.router.routerDelegate.navigatorKey.currentContext!;
}
