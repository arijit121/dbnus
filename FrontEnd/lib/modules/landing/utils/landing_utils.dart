import '../../../router/router_manager.dart';
import '../../../router/router_name.dart';
import '../../../utils/text_utils.dart';
import '../model/navigation_bar_model.dart';

class LandingUtils {
  static List<NavigationBarModel> listNavigationBar = [
    NavigationBarModel(
        title: TextUtils.dashboard,
        icon:
            'https://dbnus-df986.web.app/assets/assets/icon/dashboard_Icon.png',
        action: RouteName.initialView),
    NavigationBarModel(
        title: TextUtils.leaderBoard,
        icon: 'https://dbnus-df986.web.app/assets/assets/icon/leaderBoard.svg',
        action: RouteName.leaderBoard),
    NavigationBarModel(
        title: TextUtils.order,
        icon:
            'https://dbnus-df986.web.app/assets/assets/icon/shopping-cart.svg',
        action: RouteName.order),
    NavigationBarModel(
        title: TextUtils.products,
        icon: 'https://dbnus-df986.web.app/assets/assets/icon/shopping.svg',
        action: RouteName.products),
    NavigationBarModel(
        title: TextUtils.settings,
        icon: 'https://dbnus-df986.web.app/assets/assets/icon/setting.svg',
        action: RouteName.settings),
    NavigationBarModel(
        title: TextUtils.logout,
        icon: 'https://dbnus-df986.web.app/assets/assets/icon/sign_out.svg',
        action: TextUtils.logout),
  ];

  static void redirect(int index) {
    RouterManager.getInstance.router
        .goNamed(listNavigationBar.elementAt(index).action);
  }
}
