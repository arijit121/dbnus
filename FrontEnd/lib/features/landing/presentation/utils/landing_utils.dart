import 'package:dbnus/shared/constants/assects_const.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import 'package:dbnus/navigation/router_manager.dart';
import 'package:dbnus/navigation/router_name.dart';
import 'package:dbnus/shared/utils/text_utils.dart';
import 'package:dbnus/features/flame_game/presentation/pages/flame_game.dart'
    deferred as flame_game;
import 'package:dbnus/features/reorderable_list/presentation/pages/my_reorderable_list.dart'
    deferred as my_reorderable_list;
import 'package:dbnus/features/test_page/presentation/pages/test_page.dart'
    deferred as test_page;
import 'package:dbnus/features/ui_temp/presentation/pages/ui_temp.dart' deferred as ui_temp;
import 'package:dbnus/features/landing/domain/entities/navigation_option.dart';

class LandingUtils {
  static List<NavigationOption> listNavigation = [
    NavigationOption(
        title: TextUtils.dashboard,
        icon: AssetsConst.dashboardIcon,
        action: RouteName.initialView),
    NavigationOption(
        title: TextUtils.leaderBoard,
        icon: AssetsConst.leaderBoard,
        action: RouteName.leaderBoard),
    NavigationOption(
        title: TextUtils.order,
        icon: AssetsConst.shoppingCart,
        action: RouteName.order),
    NavigationOption(
        title: TextUtils.game, icon: AssetsConst.game, action: RouteName.games),
    NavigationOption(
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
