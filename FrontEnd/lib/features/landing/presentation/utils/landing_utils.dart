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
import 'package:dbnus/features/leader_board/presentation/pages/leader_board.dart'
    deferred as my_reorderable_list;
import 'package:dbnus/features/dashboard/presentation/pages/dashboard.dart'
    deferred as test_page;
import 'package:dbnus/features/order/presentation/pages/order.dart'
    deferred as ui_temp;
import 'package:dbnus/features/landing/domain/entities/navigation_option.dart';

import '../../../../core/localization/extension/localization_ext.dart';

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
        title: TextUtils.bioData,
        icon: AssetsConst.callIcon,
        action: RouteName.bioData),
  ];

  static Future<Widget?> getUi({required String action}) async {
    switch (action) {
      case RouteName.initialView:
        await test_page.loadLibrary();
        return test_page.DashBoardPage();

      case RouteName.leaderBoard:
        await my_reorderable_list.loadLibrary();
        return my_reorderable_list.LeaderBoard();

      case RouteName.order:
        await ui_temp.loadLibrary();
        return ui_temp.Order();

      case RouteName.games:
        await flame_game.loadLibrary();
        return flame_game.FlameGame();
    }
    return null;
  }

  static String getTranslatedTitle(BuildContext context, String title) {
    final l10n = context.l10n;
    switch (title) {
      case TextUtils.dashboard:
        return l10n.dashboard;
      case TextUtils.leaderBoard:
        return l10n.leader_board;
      case TextUtils.order:
        return l10n.order;
      case TextUtils.game:
        return l10n.game;
      case TextUtils.bioData:
        return l10n.bioData;
      default:
        return title;
    }
  }

  static Future<void> redirect(String action) async {
    GoRouter router = RouterManager.getInstance.router;
    if (kIsWeb) {
      router.goNamed(action);
    } else {
      Widget? ui = await getUi(action: action);
      if (ui != null) {
        router.replaceNamed(action);
      } else {
        router.pushNamed(action);
      }
    }
  }
}
