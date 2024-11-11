import 'package:dbnus/const/assects_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../../../router/router_manager.dart';
import '../../../router/router_name.dart';
import '../../../utils/text_utils.dart';
import '../../flame_game/ui/flame_game.dart';
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
        ui: MyReOrderAbleList()),
    NavigationModel(
        title: TextUtils.order,
        icon: AssetsConst.shoppingCart,
        action: RouteName.order,
        ui: const UiTemp()),
    NavigationModel(
        title: TextUtils.game,
        icon: AssetsConst.game,
        action: RouteName.games,
        ui: FlameGame()),
    NavigationModel(
        title: TextUtils.logout,
        icon: AssetsConst.signOut,
        action: TextUtils.logout,
        ui: null),
  ];

  static void redirect(int index) {
    GoRouter router = RouterManager.getInstance.router;
    kIsWeb
        ? router.goNamed(listNavigation.elementAt(index).action)
        : router.replaceNamed(listNavigation.elementAt(index).action);
  }
}
