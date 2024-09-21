import 'package:dbnus/const/assects_const.dart';
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
        icon: AssetsConst.dashboardIcon,
        action: RouteName.initialView,
        ui: const TestPage()),
    NavigationModel(
        title: TextUtils.leaderBoard,
        icon: AssetsConst.leaderBoard,
        action: RouteName.leaderBoard,
        ui: MyReorderableList()),
    NavigationModel(
        title: TextUtils.order,
        icon: AssetsConst.shoppingCart,
        action: RouteName.order,
        ui: const UiTemp()),
    NavigationModel(
        title: TextUtils.products,
        icon: AssetsConst.shopping,
        action: RouteName.products,
        ui: Container()),
    NavigationModel(
        title: TextUtils.settings,
        icon: AssetsConst.setting,
        action: RouteName.settings,
        ui: Container()),
    NavigationModel(
        title: TextUtils.logout,
        icon: AssetsConst.signOut,
        action: TextUtils.logout,
        ui: null),
  ];

  static void redirect(int index) {
    RouterManager.getInstance.router
        .goNamed(listNavigation.elementAt(index).action);
  }
}
