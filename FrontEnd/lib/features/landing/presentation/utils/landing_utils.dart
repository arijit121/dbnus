import 'package:dbnus/shared/constants/assects_const.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import 'package:dbnus/navigation/router_manager.dart';
import 'package:dbnus/navigation/router_name.dart';
import 'package:dbnus/shared/utils/text_utils.dart';

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
        icon: AssetsConst.shieldIcon,
        action: RouteName.bioData),
  ];

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

  static Future<void> redirect(String action, {bool uiContain = true}) async {
    GoRouter router = RouterManager.getInstance.router;
    if (kIsWeb) {
      router.goNamed(action);
    } else {
      if (uiContain) {
        router.replaceNamed(action);
      } else {
        router.pushNamed(action);
      }
    }
  }
}
