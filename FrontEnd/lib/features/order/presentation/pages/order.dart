import 'package:dbnus/core/models/custom_notification_model.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:dbnus/shared/constants/api_url_const.dart';
import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/logger_extension.dart';
import 'package:dbnus/navigation/custom_router/custom_route.dart';
import 'package:dbnus/navigation/router_name.dart';
import 'package:dbnus/core/services/JsService/provider/js_provider.dart';
import 'package:dbnus/core/services/download_handler.dart';
import 'package:dbnus/core/services/file_picker.dart';
import 'package:dbnus/core/services/notification_handler.dart';
import 'package:dbnus/core/services/open_service.dart';
import 'package:dbnus/shared/utils/pop_up_items.dart';
import 'package:dbnus/shared/ui/atoms/buttons/custom_button.dart';
import 'package:dbnus/shared/ui/molecules/dropdowns/custom_dropdown.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:dbnus/shared/ui/atoms/inputs/custom_text_formfield.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  final TextEditingController _pinController = TextEditingController();
  final ValueNotifier<bool> boolNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<bool> clearPin = ValueNotifier<bool>(false);
  int? notificationId;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // ── Header ──────────────────────────────────────────
        _buildHeader(),
        24.ph,

        // ── Notifications & Downloads ───────────────────────
        _buildSectionTitle("Notifications & Downloads", FeatherIcons.bell),
        12.ph,
        _buildNotificationsSection(),
        24.ph,

        // ── JS & Navigation ─────────────────────────────────
        _buildSectionTitle("JS & Navigation", FeatherIcons.code),
        12.ph,
        _buildJsNavigationSection(),
        24.ph,

        // ── Pin Code ────────────────────────────────────────
        _buildSectionTitle("Pin Code", FeatherIcons.lock),
        12.ph,
        _buildPinCodeSection(),
        24.ph,

        // ── Forms & Inputs ──────────────────────────────────
        _buildSectionTitle("Forms & Inputs", FeatherIcons.edit3),
        12.ph,
        _buildFormsSection(),
        24.ph,

        // ── Maps & Location ─────────────────────────────────
        _buildSectionTitle("Maps & Location", FeatherIcons.mapPin),
        12.ph,
        _buildMapsSection(),
        24.ph,
      ],
    );
  }

  // ─── Header ────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorConst.deepBlue,
            ColorConst.lightBlue,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: ColorConst.deepBlue.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                Icon(FeatherIcons.shoppingBag, color: Colors.white, size: 24),
          ),
          16.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  "Orders",
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  size: 22,
                ),
                4.ph,
                CustomText(
                  "Manage orders, notifications & tools",
                  color: Colors.white70,
                  size: 13,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Section Title ─────────────────────────────────────────────
  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: ColorConst.primaryDark),
        10.pw,
        CustomText(
          title,
          fontWeight: FontWeight.w600,
          size: 18,
          color: ColorConst.primaryDark,
        ),
      ],
    );
  }

  // ─── Notifications & Downloads ─────────────────────────────────
  Widget _buildNotificationsSection() {
    return Container(
      decoration: BoxDecoration(
        color: ColorConst.cardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildToolTile(
            icon: FeatherIcons.download,
            title: "Download PDF",
            subtitle: "Download sample 1MB PDF file",
            color: ColorConst.lightBlue,
            onTap: () {
              DownloadHandler.download(
                  downloadUrl:
                      "https://file-examples.com/storage/fe6146b54768752f9a08cf7/2017/10/file-example_PDF_1MB.pdf");
            },
          ),
          _buildDivider(),
          _buildToolTile(
            icon: FeatherIcons.bell,
            title: "Show Notification",
            subtitle: "Display a sample push notification",
            color: ColorConst.violate,
            onTap: () async {
              notificationId =
                  await NotificationHandler.showUpdateFlutterNotification(
                CustomNotificationModel(
                  title: "Silent Notification4",
                  message: "test",
                  bigText:
                      "<p>This is<sub> subscript</sub> and <sup>superscript</sup></p>",
                  imageUrl: ApiUrlConst.testImgUrl(),
                  sound: "slow_spring_board",
                ),
              );
            },
          ),
          _buildDivider(),
          _buildToolTile(
            icon: FeatherIcons.refreshCw,
            title: "Update Notification",
            subtitle: "Update the last shown notification",
            color: Color(0xFFE67E22),
            onTap: () {
              NotificationHandler.showUpdateFlutterNotification(
                CustomNotificationModel(
                  title: "Silent Notification update",
                  message: "test $notificationId",
                  bigText:
                      "<p>This is<sub> subscript</sub> and <sup>superscript</sup></p>",
                  imageUrl: ApiUrlConst.testImgUrl(),
                  sound: "slow_spring_board",
                ),
                notificationId: notificationId,
              );
            },
          ),
        ],
      ),
    );
  }

  // ─── JS & Navigation ──────────────────────────────────────────
  Widget _buildJsNavigationSection() {
    return Container(
      decoration: BoxDecoration(
        color: ColorConst.cardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildToolTile(
            icon: FeatherIcons.terminal,
            title: "JS Callback Async",
            subtitle: "Load JS and pass value with callback",
            color: Color(0xFF8E44AD),
            onTap: () async {
              String? value =
                  await JsProvider.loadJsAndPassValueWithCallbackAsync(
                      value: "testvdshvhfvsfhvs");
              AppLog.i(value);
            },
          ),
          _buildDivider(),
          _buildToolTile(
            icon: FeatherIcons.link,
            title: "Change URL",
            subtitle: "Change browser URL to /test",
            color: ColorConst.lightBlue,
            onTap: () async {
              await JsProvider.changeUrl(path: "/test");
            },
          ),
          _buildDivider(),
          _buildToolTile(
            icon: FeatherIcons.uploadCloud,
            title: "File Picker",
            subtitle: "Pick a file from your device",
            color: ColorConst.deepGreen,
            onTap: () {
              CustomFilePicker.customFilePicker();
            },
          ),
          _buildDivider(),
          _buildToolTile(
            icon: FeatherIcons.arrowRight,
            title: "Clear & Navigate to LeaderBoard",
            subtitle: "Clear stack and go to leaderboard",
            color: ColorConst.red,
            onTap: () {
              CustomRoute.clearAndNavigateName(RouteName.leaderBoard);
            },
          ),
          _buildDivider(),
          _buildToolTile(
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
          _buildToolTile(
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
          _buildToolTile(
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

  // ─── Pin Code Section ──────────────────────────────────────────
  Widget _buildPinCodeSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorConst.cardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: ValueListenableBuilder<bool>(
                    valueListenable: boolNotifier,
                    builder: (context, value, child) {
                      return CustomGOEButton(
                          onPressed: () {
                            boolNotifier.value = !boolNotifier.value;
                            if (_pinController.text.isNotEmpty) {
                              _pinController.clear();
                              clearPin.value = false;
                            }
                          },
                          gradient: LinearGradient(colors: [
                            Color(0xFFE67E22),
                            Color(0xFFD35400),
                          ]),
                          borderRadius: BorderRadius.circular(10),
                          child: CustomText(
                            "Pin-code ${boolNotifier.value ? 'hide' : 'show'}",
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ));
                    }),
              ),
              12.pw,
              Expanded(
                child: ValueListenableBuilder<bool>(
                    valueListenable: boolNotifier,
                    builder: (context, value, child) {
                      return boolNotifier.value
                          ? CustomGOEButton(
                              onPressed: () {
                                if (_pinController.text.isNotEmpty) {
                                  _pinController.clear();
                                  clearPin.value = false;
                                } else {
                                  _pinController.text = "55554";
                                  clearPin.value = true;
                                }
                              },
                              gradient: LinearGradient(colors: [
                                ColorConst.violate,
                                ColorConst.sidebarSelected,
                              ]),
                              borderRadius: BorderRadius.circular(10),
                              child: ValueListenableBuilder<bool>(
                                  valueListenable: clearPin,
                                  builder: (context, value, child) {
                                    return CustomText(
                                      clearPin.value
                                          ? 'Clear Pin'
                                          : 'Set 55554',
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    );
                                  }))
                          : SizedBox.shrink();
                    }),
              ),
            ],
          ),
          ValueListenableBuilder<bool>(
              valueListenable: boolNotifier,
              builder: (context, value, child) {
                return boolNotifier.value
                    ? Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: PinCodeFormField(
                          controller: _pinController,
                          length: 5,
                          autoFocus: true,
                          autoFill: true,
                          onCompleted: (value) {
                            AppLog.i(_pinController.text, tag: "OnCompleted");
                          },
                        ))
                    : SizedBox.shrink();
              }),
        ],
      ),
    );
  }

  // ─── Forms Section ─────────────────────────────────────────────
  Widget _buildFormsSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorConst.cardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(fieldHeight: 200),
          16.ph,
          CustomTextFormField(),
          16.ph,
          CustomTextFormField(maxLines: 1),
          16.ph,
          CustomDropdownMenuFormField<String>(
              hintText: "Please choose val",
              suffix: const Icon(Icons.keyboard_arrow_down_rounded),
              onChanged: (value) {
                AppLog.d(value);
              },
              items: List.generate(
                  10,
                  (index) => CustomDropDownModel<String>(
                      value: "test$index", title: "test$index"))),
          16.ph,
          CustomMenuAnchor<String>(
            onPressed: (value) {
              AppLog.d(value);
            },
            items: List.generate(
                10,
                (index) => CustomDropDownModel<String>(
                    value: "test$index", title: "test$index")),
            child: const Icon(
              Icons.zoom_out_rounded,
              color: Colors.amber,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Maps Section ──────────────────────────────────────────────
  Widget _buildMapsSection() {
    return Container(
      decoration: BoxDecoration(
        color: ColorConst.cardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildToolTile(
            icon: FeatherIcons.search,
            title: "Open Kolkata in Maps",
            subtitle: "Search by address with directions",
            color: ColorConst.deepGreen,
            onTap: () {
              OpenService.openAddressInMap(address: 'Kolkata', direction: true);
            },
          ),
          _buildDivider(),
          _buildToolTile(
            icon: FeatherIcons.navigation,
            title: "Open Coordinates",
            subtitle: "Lat: 22.5354, Lng: 88.3474",
            color: ColorConst.lightBlue,
            onTap: () {
              OpenService.openCoordinatesInMap(
                latitude: 22.5354273,
                longitude: 88.3473527,
              );
            },
          ),
        ],
      ),
    );
  }

  // ─── Shared Helpers ────────────────────────────────────────────
  Widget _buildDivider() =>
      Divider(height: 1, indent: 56, color: ColorConst.lineGrey);

  Widget _buildToolTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              14.pw,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      title,
                      fontWeight: FontWeight.w600,
                      size: 14,
                      color: ColorConst.primaryDark,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    2.ph,
                    CustomText(
                      subtitle,
                      size: 12,
                      color: ColorConst.secondaryDark,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(FeatherIcons.chevronRight, color: ColorConst.grey, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
