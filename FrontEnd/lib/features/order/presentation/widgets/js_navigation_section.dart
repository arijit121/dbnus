import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:feather_icons/feather_icons.dart';

import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/logger_extension.dart';
import 'package:dbnus/navigation/custom_router/custom_route.dart';
import 'package:dbnus/navigation/router_name.dart';
import 'package:dbnus/core/services/JsService/provider/js_provider.dart';
import 'package:dbnus/core/services/file_picker.dart';
import 'package:dbnus/shared/utils/pop_up_items.dart';

import 'order_tool_tile.dart';

class JsNavigationSection extends StatelessWidget {
  const JsNavigationSection({super.key});

  Widget _buildDivider() =>
      const Divider(height: 1, indent: 56, color: ColorConst.lineGrey);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorConst.cardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          OrderToolTile(
            icon: FeatherIcons.terminal,
            title: "JS Callback Async",
            subtitle: "Load JS and pass value with callback",
            color: const Color(0xFF8E44AD),
            onTap: () async {
              String? value =
                  await JsProvider.loadJsAndPassValueWithCallbackAsync(
                      value: "testvdshvhfvsfhvs");
              AppLog.i(value);
            },
          ),
          _buildDivider(),
          OrderToolTile(
            icon: FeatherIcons.link,
            title: "Change URL",
            subtitle: "Change browser URL to /test",
            color: ColorConst.lightBlue,
            onTap: () async {
              await JsProvider.changeUrl(path: "/test");
            },
          ),
          _buildDivider(),
          OrderToolTile(
            icon: FeatherIcons.uploadCloud,
            title: "File Picker",
            subtitle: "Pick a file from your device",
            color: ColorConst.deepGreen,
            onTap: () {
              CustomFilePicker.customFilePicker();
            },
          ),
          _buildDivider(),
          OrderToolTile(
            icon: FeatherIcons.arrowRight,
            title: "Clear & Navigate to LeaderBoard",
            subtitle: "Clear stack and go to leaderboard",
            color: ColorConst.red,
            onTap: () {
              CustomRoute.clearAndNavigateName(RouteName.leaderBoard);
            },
          ),
          _buildDivider(),
          OrderToolTile(
            icon: FeatherIcons.play,
            title: "Navigate to Games",
            subtitle: "Go to the games page",
            color: ColorConst.violate,
            onTap: () {
              kIsWeb
                  ? context.goNamed(RouteName.games)
                  : context.pushNamed(RouteName.games);
            },
          ),
          _buildDivider(),
          OrderToolTile(
            icon: FeatherIcons.checkCircle,
            title: "Show Success",
            subtitle: "Display success message popup",
            color: ColorConst.green,
            onTap: () {
              PopUpItems.customMsgDialog(
                  title: "Success",
                  content: "Thank you, transaction complete.",
                  type: DialogType.success);
            },
          ),
          _buildDivider(),
          OrderToolTile(
            icon: FeatherIcons.messageSquare,
            title: "Show Toast",
            subtitle: "Display a toast message",
            color: ColorConst.primaryDark,
            onTap: () {
              PopUpItems.toastMessage(
                  "Show tost msg..", ColorConst.primaryDark);
            },
          ),
        ],
      ),
    );
  }
}
