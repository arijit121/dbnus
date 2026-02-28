import 'dart:math';

import 'package:dbnus/core/models/custom_file.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/navigation/router_name.dart';
import 'package:dbnus/core/localization/extension/localization_ext.dart';
import 'package:dbnus/core/services/file_picker.dart';
import 'package:dbnus/shared/utils/screen_utils.dart';
import 'package:dbnus/shared/ui/atoms/inputs/custom_text_formfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:feather_icons/feather_icons.dart';

import 'package:dbnus/core/config/app_config.dart';
import 'package:dbnus/shared/constants/api_url_const.dart';
import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/core/services/models/forward_geocoding.dart';
import 'package:dbnus/core/network/models/razorpay_merchant_details.dart';
import 'package:dbnus/core/services/models/reverse_geocoding.dart';
import 'package:dbnus/shared/extensions/logger_extension.dart';
import 'package:dbnus/flavors.dart';
import 'package:dbnus/navigation/custom_router/custom_route.dart';
import 'package:dbnus/core/localization/utils/localization_utils.dart';
import 'package:dbnus/core/services/download_handler.dart';
import 'package:dbnus/core/services/geocoding.dart';
import 'package:dbnus/shared/utils/pop_up_items.dart';
import 'package:dbnus/shared/utils/text_utils.dart';
import 'package:dbnus/shared/ui/organisms/carousels/carousel_slider.dart';
import 'package:dbnus/shared/ui/atoms/buttons/custom_button.dart';
import 'package:dbnus/shared/ui/atoms/images/custom_image.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:dbnus/shared/ui/organisms/scrolls/smooth_scroll.dart';
import 'package:dbnus/shared/ui/organisms/video/youtube_video_player.dart';
import 'package:dbnus/features/payment_gateway/data/models/web_view_payment_gateway_model.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  ValueNotifier<int> counter = ValueNotifier(0);
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _midController = TextEditingController();
  final TextEditingController _orderIdController = TextEditingController();
  final TextEditingController _txnTokenController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SmoothScroll(
            primary: false,
            children: [
              // ── Welcome Header ──────────────────────────────────
              _buildWelcomeHeader(),
              24.ph,

              // ── Quick Actions ───────────────────────────────────
              _buildSectionTitle("Quick Actions", FeatherIcons.zap),
              12.ph,
              _buildQuickActionsGrid(),
              24.ph,

              // ── Tools & Utilities ───────────────────────────────
              _buildSectionTitle("Tools & Utilities", FeatherIcons.tool),
              12.ph,
              _buildToolsSection(),
              24.ph,

              // ── Payment Gateway ─────────────────────────────────
              _buildSectionTitle("Payment Gateway", FeatherIcons.creditCard),
              12.ph,
              _buildPaymentSection(),
              24.ph,

              // ── Media Gallery ───────────────────────────────────
              _buildSectionTitle("Media Gallery", FeatherIcons.image),
              12.ph,
              _buildMediaSection(),
              24.ph,
            ],
          ),
        ),
      ],
    );
  }

  // ─── Welcome Header ──────────────────────────────────────────────
  Widget _buildWelcomeHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorConst.sidebarBg,
            Color(0xFF2D3250),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: ColorConst.sidebarBg.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(FeatherIcons.home, color: Colors.white, size: 24),
              ),
              16.pw,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      context.l10n?.hello_world ?? TextUtils.hello_world,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      size: 22,
                    ),
                    4.ph,
                    CustomText(
                      "${F.title} • ${F.name}",
                      color: Colors.white70,
                      size: 13,
                    ),
                  ],
                ),
              ),
              ValueListenableBuilder(
                valueListenable: counter,
                builder: (BuildContext context, int value, Widget? child) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      counter.value = counter.value + 1;
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(FeatherIcons.activity,
                              color: Colors.white, size: 16),
                          8.pw,
                          CustomText(
                            "$value",
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Section Title ───────────────────────────────────────────────
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

  // ─── Quick Actions Grid ──────────────────────────────────────────
  Widget _buildQuickActionsGrid() {
    final actions = [
      _QuickAction(
        icon: FeatherIcons.globe,
        label: "Change Language",
        gradient: [ColorConst.violate, ColorConst.sidebarSelected],
        onTap: () {
          LocalizationUtils.changeLanguage(
              locale: LocalizationUtils.supportedLocales[
                  Random().nextInt(LocalizationUtils.supportedLocales.length)]);
        },
      ),
      _QuickAction(
        icon: FeatherIcons.fileText,
        label: "Order Details",
        gradient: [ColorConst.lightBlue, ColorConst.deepBlue],
        onTap: () {
          kIsWeb
              ? context.goNamed(RouteName.orderDetails,
                  pathParameters: {"order_id": "56"})
              : context.pushNamed(RouteName.orderDetails,
                  pathParameters: {"order_id": "56"});
        },
      ),
      _QuickAction(
        icon: FeatherIcons.barChart2,
        label: "Leaderboard",
        gradient: [ColorConst.deepGreen, Color(0xFF1B7A4D)],
        onTap: () {
          kIsWeb
              ? context.goNamed(RouteName.leaderBoard)
              : context.pushNamed(RouteName.leaderBoard);
        },
      ),
      _QuickAction(
        icon: FeatherIcons.uploadCloud,
        label: "File Pick",
        gradient: [Color(0xFFE67E22), Color(0xFFD35400)],
        onTap: () async {
          CustomFile? customFile = await CustomFilePicker.customFilePicker();
          AppLog.i(customFile?.name, tag: "CustomFile");
        },
      ),
      _QuickAction(
        icon: FeatherIcons.smartphone,
        label: "Device ID",
        gradient: [Color(0xFF8E44AD), Color(0xFF6C3483)],
        onTap: () async {
          String? deviceId = await AppConfig().getDeviceId();
          AppLog.i(deviceId);
          PopUpItems.toastMessage(deviceId ?? "", Colors.green);
        },
      ),
      _QuickAction(
        icon: FeatherIcons.dollarSign,
        label: "Razorpay",
        gradient: [ColorConst.lightBlue, ColorConst.violate],
        onTap: () async {
          CustomRoute.pushNamed(
              name: RouteName.rayzorPay, arguments: RazorpayMerchantDetails());
        },
      ),
    ];

    return LayoutBuilder(builder: (context, constraints) {
      int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
      return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.6,
        ),
        itemCount: actions.length,
        itemBuilder: (context, index) {
          final action = actions[index];
          return _buildActionCard(action);
        },
      );
    });
  }

  Widget _buildActionCard(_QuickAction action) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: action.onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: action.gradient,
            ),
            boxShadow: [
              BoxShadow(
                color: action.gradient.first.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(action.icon, color: Colors.white, size: 20),
              ),
              CustomText(
                action.label,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                size: 13,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Tools Section ───────────────────────────────────────────────
  Widget _buildToolsSection() {
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
            title: "Download GlucoseFasting PDF",
            subtitle: "Download sample report",
            color: ColorConst.deepGreen,
            onTap: () {
              DownloadHandler.download(
                  downloadUrl:
                      "https://res.genupathlabs.com/genu_path_lab/live/customer_V2/sample_report/GlucoseFasting.pdf");
            },
          ),
          Divider(height: 1, indent: 56, color: ColorConst.lineGrey),
          _buildToolTile(
            icon: FeatherIcons.downloadCloud,
            title: "Download with Headers",
            subtitle: "Authenticated download",
            color: ColorConst.lightBlue,
            onTap: () {
              DownloadHandler.download(
                  downloadUrl:
                      "http://65.0.139.63:5001/api/admin/invoices/676f20131e1add0f4b4b2a58/pdf",
                  headers: {
                    "Authentication":
                        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3N2FkM2Y3ZWQxZmQxZDA2YjgyMTliYiIsImlhdCI6MTczNjEwMjkwM30.RtRG7Sr6sPjCJX26Otmd9SWWfzF67_8ZzUIiblbJRZ8",
                    "App-Type": "A",
                    "App-Version": "1.0.0",
                    "Content-Type": "application/json",
                    "Device-Id": "7f9bfffbb6adeb27",
                    "Device-Density-Type": "xhdpi",
                    "Device-Name": "V2217A",
                    "Network-Info": "wifi",
                    "Device-Width": "431.30434782608694",
                    "Device-Os-Info": "9",
                    "Device-Height": "834.7826086956521",
                    "Device-Density": "560",
                    "App-Version-Code": "1"
                  });
            },
          ),
          Divider(height: 1, indent: 56, color: ColorConst.lineGrey),
          _buildToolTile(
            icon: FeatherIcons.mapPin,
            title: "Forward Geocoding",
            subtitle: "Jot Bhim, New Town, Bidhannagar",
            color: ColorConst.violate,
            onTap: () async {
              ForwardGeocoding? forwardGeocoding = await Geocoding.forwardGeocoding(
                  address:
                      "Jot Bhim, New Town, Bidhannagar, North 24 Parganas District, West Bengal, 700160, India");
              AppLog.i(forwardGeocoding?.longitude);
            },
          ),
          Divider(height: 1, indent: 56, color: ColorConst.lineGrey),
          _buildToolTile(
            icon: FeatherIcons.navigation,
            title: "Reverse Geocoding",
            subtitle: "Lat: 22.5754, Lng: 88.4798",
            color: Color(0xFFE67E22),
            onTap: () async {
              ReverseGeocoding? reverseGeocoding =
                  await Geocoding.reverseGeocoding(
                      latitude: 22.5754, longitude: 88.4798);
              AppLog.i(reverseGeocoding?.displayName);
            },
          ),
          Divider(height: 1, indent: 56, color: ColorConst.lineGrey),
          _buildToolTile(
            icon: FeatherIcons.checkCircle,
            title: "Show Success Dialog",
            subtitle: "Display success message popup",
            color: ColorConst.green,
            onTap: () {
              PopUpItems.customMsgDialog(
                  title: "Success",
                  content: "Thank you, transaction complete.",
                  type: DialogType.success);
            },
          ),
        ],
      ),
    );
  }

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

  // ─── Payment Section ─────────────────────────────────────────────
  Widget _buildPaymentSection() {
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
          CustomTextFormField(
            controller: _amountController,
            title: 'Amount',
          ),
          16.ph,
          CustomTextFormField(
            controller: _midController,
            title: 'MID',
          ),
          16.ph,
          CustomTextFormField(
            controller: _orderIdController,
            title: 'Order ID',
          ),
          16.ph,
          CustomTextFormField(
            title: 'Txn Token',
            controller: _txnTokenController,
          ),
          20.ph,
          SizedBox(
            width: double.infinity,
            child: CustomGOEButton(
                onPressed: () async {
                  CustomRoute.pushNamed(
                    name: RouteName.webViewPaymentGateway,
                    arguments: WebViewPaymentGatewayModel(
                      paymentLink:
                          'https://res.retailershakti.com/rs_live/msiteflutter/msite/static/paytm_view.html?amount=${_amountController.text}&mid=${_midController.text}&orderId=${_orderIdController.text}&txnToken=${_txnTokenController.text}',
                      redirectLink:
                          'https://www.retailershakti.com/retailCart/payment',
                      transactionId: _orderIdController.text,
                      title: "Paytm",
                    ),
                  );
                },
                gradient: LinearGradient(
                  colors: [ColorConst.violate, ColorConst.sidebarSelected],
                ),
                // borderRadius: 12,
                child: const CustomText("Pay with Paytm",
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  // ─── Media Section ───────────────────────────────────────────────
  Widget _buildMediaSection() {
    return Column(
      children: [
        // YouTube
        Container(
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
          clipBehavior: Clip.antiAlias,
          child: YoutubeVideoPlayer(
            videoUrl: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
            height: 220,
          ),
        ),
        20.ph,

        // Image row
        Row(
          spacing: 12,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  PopUpItems.toastMessage("On Tap", ColorConst.baseHexColor);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: CustomNetWorkImageView(
                    url: ApiUrlConst.testImgUrl(),
                    radius: 14,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CustomNetWorkImageView(
                  url: "${ApiUrlConst.testImgUrl()}lfmbldmfbl",
                  radius: 14,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
        20.ph,

        // Carousel
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: CarouselSlider(
            radius: 14,
            autoScrollDuration: Duration(seconds: 4),
            imageList: List.generate(5, (int index) {
              return index == 2
                  ? ApiUrlConst.testImgUrl(aspectRatio: 16 / 9)
                  : ApiUrlConst.testImgUrl();
            }),
            onTap: (index) {
              kIsWeb
                  ? context.goNamed(RouteName.games)
                  : context.pushNamed(RouteName.games);
            },
            height: 400,
          ),
        ),
        20.ph,

        // Image pairs
        Row(
          spacing: 12,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CustomNetWorkImageView(
                  url: ApiUrlConst.testImgUrl(),
                  radius: 14,
                  height: ScreenUtils.nw() / 2,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CustomNetWorkImageView(
                  url: ApiUrlConst.testImgUrl(),
                  radius: 14,
                  height: ScreenUtils.nw() / 2,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
        20.ph,

        Row(
          spacing: 12,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CustomNetWorkImageView(
                  url: ApiUrlConst.testImgUrl(),
                  radius: 14,
                  height: 100,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CustomNetWorkImageView(
                  url:
                      "https://stage-cdn.aadharhealth.in/incom/app_images/1726653030_accessories.png",
                  radius: 14,
                  height: 100,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
        20.ph,

        // More carousels and images
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: CarouselSlider(
            radius: 14,
            autoScrollDuration: Duration(seconds: 4),
            imageList: List.generate(5, (int index) {
              return index == 2
                  ? ApiUrlConst.testImgUrl(aspectRatio: 16 / 9)
                  : ApiUrlConst.testImgUrl();
            }),
            onTap: (index) {
              kIsWeb
                  ? context.goNamed(RouteName.games)
                  : context.pushNamed(RouteName.games);
            },
            height: 400,
          ),
        ),
        20.ph,
        Row(
          spacing: 12,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CustomNetWorkImageView(
                  url: ApiUrlConst.testImgUrl(),
                  radius: 14,
                  height: ScreenUtils.nw() / 2,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CustomNetWorkImageView(
                  url: ApiUrlConst.testImgUrl(),
                  radius: 14,
                  height: ScreenUtils.nw() / 2,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
        20.ph,
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: CarouselSlider(
            radius: 14,
            autoScrollDuration: Duration(seconds: 4),
            imageList: List.generate(5, (int index) {
              return index == 2
                  ? ApiUrlConst.testImgUrl(aspectRatio: 16 / 9)
                  : ApiUrlConst.testImgUrl();
            }),
            onTap: (index) {
              kIsWeb
                  ? context.goNamed(RouteName.games)
                  : context.pushNamed(RouteName.games);
            },
            height: 400,
          ),
        ),
        20.ph,
        Row(
          spacing: 12,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CustomNetWorkImageView(
                  url: ApiUrlConst.testImgUrl(),
                  radius: 14,
                  height: ScreenUtils.nw() / 2,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CustomNetWorkImageView(
                  url: ApiUrlConst.testImgUrl(),
                  radius: 14,
                  height: ScreenUtils.nw() / 2,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
        20.ph,
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: CustomNetWorkImageView(
            url: ApiUrlConst.testImgUrl(
                aspectRatio: ScreenUtils.nw() / (ScreenUtils.nw() / 2)),
            radius: 14,
            height: ScreenUtils.nw() / 2,
            fit: BoxFit.fill,
          ),
        ),
        20.ph,
      ],
    );
  }
}

/// Internal data class for quick action cards
class _QuickAction {
  final IconData icon;
  final String label;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });
}
