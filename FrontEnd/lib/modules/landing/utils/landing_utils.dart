import 'package:dbnus/const/assects_const.dart';
import 'package:dbnus/extension/spacing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../../../router/router_manager.dart';
import '../../../router/router_name.dart';
import '../../../utils/text_utils.dart';
import '../../flame_game/ui/flame_game.dart' deferred as flame_game;
import '../../reorderable_list/ui/my_reorderable_list.dart'
    deferred as my_reorderable_list;
import '../../test_page/ui/test_page.dart' deferred as test_page;
import '../../ui_temp/ui/ui_temp.dart' deferred as ui_temp;
import '../model/navigation_model.dart';

class LandingUtils {
  static List<NavigationModel> listNavigation = [
    NavigationModel(
        title: TextUtils.dashboard,
        icon: AssetsConst.dashboardIcon,
        action: RouteName.initialView),
    NavigationModel(
        title: TextUtils.leaderBoard,
        icon: AssetsConst.leaderBoard,
        action: RouteName.leaderBoard),
    NavigationModel(
        title: TextUtils.order,
        icon: AssetsConst.shoppingCart,
        action: RouteName.order),
    NavigationModel(
        title: TextUtils.game, icon: AssetsConst.game, action: RouteName.games),
    NavigationModel(
        title: TextUtils.logout,
        icon: AssetsConst.signOut,
        action: TextUtils.logout),
  ];

  Future<Widget> getUi({required String action}) async {
    switch (action) {
      case RouteName.initialView:
        await test_page.loadLibrary();
        return test_page.TestPage();

      case RouteName.leaderBoard:
        await my_reorderable_list.loadLibrary();
        return my_reorderable_list.MyReOrderAbleList();

      case RouteName.order:
        await ui_temp.loadLibrary();
        return ui_temp.UiTemp();

      case RouteName.games:
        await flame_game.loadLibrary();
        return flame_game.FlameGame();

      default:
        return 0.ph;
    }
  }

  static void redirect(int index) {
    GoRouter router = RouterManager.getInstance.router;
    kIsWeb
        ? router.goNamed(listNavigation.elementAt(index).action)
        : router.replaceNamed(listNavigation.elementAt(index).action);
  }
}
