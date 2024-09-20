import 'package:flutter/cupertino.dart';
import '../../../router/router_manager.dart';
import '../../../router/router_name.dart';
import '../../../utils/text_utils.dart';
import '../../reorderable_list/ui/my_reorderable_list.dart';
import '../../test_page/ui/test_page.dart';
import '../../ui_temp/ui/ui_temp.dart';
import '../model/navigation_model.dart';

class LandingUtils {
  static List<NavigationModel> listNavigation = [
    NavigationModel(
        title: TextUtils.dashboard,
        icon:
            'https://dbnus-df986.web.app/assets/assets/icon/dashboard_Icon.png',
        action: RouteName.initialView,
        ui: const TestPage()),
    NavigationModel(
        title: TextUtils.leaderBoard,
        icon: 'https://dbnus-df986.web.app/assets/assets/icon/leaderBoard.svg',
        action: RouteName.leaderBoard,
        ui: MyReorderableList()),
    NavigationModel(
        title: TextUtils.order,
        icon:
            'https://dbnus-df986.web.app/assets/assets/icon/shopping-cart.svg',
        action: RouteName.order,
        ui: const UiTemp()),
    NavigationModel(
        title: TextUtils.products,
        icon: 'https://dbnus-df986.web.app/assets/assets/icon/shopping.svg',
        action: RouteName.products,
        ui: Container()),
    NavigationModel(
        title: TextUtils.settings,
        icon: 'https://dbnus-df986.web.app/assets/assets/icon/setting.svg',
        action: RouteName.settings,
        ui: Container()),
    NavigationModel(
        title: TextUtils.logout,
        icon: 'https://dbnus-df986.web.app/assets/assets/icon/sign_out.svg',
        action: TextUtils.logout,
        ui: null),
  ];

  static void redirect(int index) {
    RouterManager.getInstance.router
        .goNamed(listNavigation.elementAt(index).action);
  }
}
