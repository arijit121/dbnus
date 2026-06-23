import 'package:dbnus/shared/ui/atoms/indicators/loading_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:dbnus/shared/constants/assects_const.dart';

import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/logger_extension.dart';
import 'package:dbnus/navigation/custom_router/custom_route.dart';
import 'package:dbnus/navigation/router_name.dart';
import 'package:dbnus/core/services/JsService/provider/js_provider.dart';
import 'package:dbnus/core/services/file_picker.dart';
import 'package:dbnus/shared/utils/pop_up_items.dart';

import '../../../../core/config/app_config.dart';
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
            icon: AssetsConst.featherTerminal,
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
            icon: AssetsConst.featherLink,
            title: "Change URL",
            subtitle: "Change browser URL to /test",
            color: ColorConst.lightBlue,
            onTap: () async {
              await JsProvider.changeUrl(path: "/test");
            },
          ),
          _buildDivider(),
          OrderToolTile(
            icon: AssetsConst.featherUploadCloud,
            title: "File Picker",
            subtitle: "Pick a file from your device",
            color: ColorConst.deepGreen,
            onTap: () {
              CustomFilePicker.customFilePicker();
            },
          ),
          _buildDivider(),
          OrderToolTile(
            icon: AssetsConst.featherArrowRight,
            title: "Clear & Navigate to LeaderBoard",
            subtitle: "Clear stack and go to leaderboard",
            color: ColorConst.red,
            onTap: () {
              CustomRoute.clearAndNavigateName(RouteName.leaderBoard);
            },
          ),
          _buildDivider(),
          OrderToolTile(
            icon: AssetsConst.featherPlay,
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
            icon: AssetsConst.featherCheckCircle,
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
            icon: AssetsConst.featherMessageSquare,
            title: "Show Toast",
            subtitle: "Display a toast message",
            color: ColorConst.primaryDark,
            onTap: () {
              PopUpItems.toastMessage(
                  "Show tost msg..", ColorConst.primaryDark);
            },
          ),
          _buildDivider(),
          OrderToolTile(
            icon: AssetsConst.featherMail,
            title: "Show Toast on BottomSheet",
            subtitle: "Display a toast message on BottomSheet",
            color: ColorConst.primaryDark,
            onTap: () {
              final GlobalKey<ScaffoldMessengerState> scaffoldKey =
                  GlobalKey<ScaffoldMessengerState>();

              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) {
                  return ScaffoldMessenger(
                    key: scaffoldKey,
                    child: Scaffold(
                      body: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            PopUpItems.toastMessage(
                              "Error occurred",
                              Colors.red,
                              scaffoldState: scaffoldKey.currentState,
                            );
                          },
                          child: Text("Show Toast"),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          _buildDivider(),
          OrderToolTile(
            icon: AssetsConst.featherLoader,
            title: "Show Loading",
            subtitle: "Display a loading widget",
            color: ColorConst.primaryDark,
            onTap: () async {
              /*PopUpItems.customMsgDialog(
                  title: "Debug",
                  content: "This is a debug message.",
                  type: DialogType.warning);*/
              final loadingDialogContext = await showLoading();
              await Future.delayed(const Duration(seconds: 2));
              hideLoading(loadingDialogContext: loadingDialogContext);
              // await Future.delayed(const Duration(seconds: 2));
              // hideLoading(loadingDialogContext: loadingDialogContext);
              // await Future.delayed(const Duration(seconds: 2));
              // hideLoading();
            },
          ),
          _buildDivider(),
          OrderToolTile(
            icon: AssetsConst.featherShield,
            title: "Show IP",
            subtitle: "IP",
            color: ColorConst.primaryDark,
            onTap: () async {
              final ip = await AppConfig().getWifiIp();
              if (ip != null) {
                PopUpItems.toastMessage(ip, Colors.red);
              }
            },
          ),
          _buildDivider(),
          OrderToolTile(
            icon: AssetsConst.featherShield,
            title: "Show IP V4",
            subtitle: "IP",
            color: ColorConst.primaryDark,
            onTap: () async {
              final ipV4 = await AppConfig().getWifiIpV4();
              if (ipV4 != null) {
                PopUpItems.toastMessage(ipV4, Colors.red);
              }
            },
          ),
          _buildDivider(),
          OrderToolTile(
            icon: AssetsConst.featherShield,
            title: "Show IP V6",
            subtitle: "IP",
            color: ColorConst.primaryDark,
            onTap: () async {
              final ipV4 = await AppConfig().getWifiIpV6();
              if (ipV4 != null) {
                PopUpItems.toastMessage(ipV4, Colors.red);
              }
            },
          ),
        ],
      ),
    );
  }
}
