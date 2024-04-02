import '../../../router/router_manager.dart';
import '../../../router/router_name.dart';

class LandingUtils {
  static void redirect(int index) {
    switch (index) {
      case 0:
        RouterManager.getInstance.router.goNamed(RouteName.initialView);
        break;
      case 1:
        RouterManager.getInstance.router.goNamed(RouteName.leaderBoard);
        break;
      case 2:
        RouterManager.getInstance.router.goNamed(RouteName.order);
        break;
      case 3:
        RouterManager.getInstance.router.goNamed(RouteName.products);
        break;
      case 4:
        RouterManager.getInstance.router.goNamed(RouteName.massage);
        break;
      case 5:
        RouterManager.getInstance.router.goNamed(RouteName.settings);
        break;
    }
  }
}
