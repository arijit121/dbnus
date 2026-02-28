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

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
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
              CustomTextEnum(
                F.title,
                styleType: CustomTextStyleType.body2,
              ),
              20.ph,
              CustomTextEnum(
                F.name,
                styleType: CustomTextStyleType.body2,
                color: ColorConst.primaryDark,
              ),
              20.ph,
              CustomIconButton(icon: const Icon(Icons.abc), onPressed: () {}),
              20.ph,
              ValueListenableBuilder(
                valueListenable: counter,
                builder: (BuildContext context, int value, Widget? child) {
                  return CustomTextButton(
                    onPressed: () {
                      counter.value = counter.value + 1;
                    },
                    child: CustomText(
                      "$value",
                      color: ColorConst.primaryDark,
                    ),
                  );
                },
              ),
              20.ph,
              CustomGOEButton(
                child: CustomText(
                    context.l10n?.hello_world ?? TextUtils.hello_world),
                onPressed: () {},
              ),
              20.ph,
              CustomGOEButton(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.red, blurRadius: 1, spreadRadius: 0.5
                        // offset: Offset(4, 8), // Shadow position
                        ),
                  ],
                  onPressed: () {
                    LocalizationUtils.changeLanguage(
                        locale: LocalizationUtils.supportedLocales[Random()
                            .nextInt(
                                LocalizationUtils.supportedLocales.length)]);
                  },
                  // gradient: const LinearGradient(colors: [
                  //   ColorConst.red,
                  //   Colors.blue,
                  // ]),
                  borderColor: Colors.blue,
                  child: const CustomText("Change language")),
              20.ph,
              CustomGOEButton(
                  onPressed: () {
                    kIsWeb
                        ? context.goNamed(RouteName.orderDetails,
                            pathParameters: {"order_id": "56"})
                        : context.pushNamed(RouteName.orderDetails,
                            pathParameters: {"order_id": "56"});
                  },
                  gradient: const LinearGradient(colors: [
                    ColorConst.red,
                    Colors.blue,
                  ]),
                  child: const CustomText("OrderDetails")),
              20.ph,
              CustomGOEButton(
                onPressed: () {},
                child: const CustomText("text"),
              ),
              20.ph,
              CustomTextButton(
                  child: const CustomText("text"), onPressed: () {}),
              20.ph,
              const CustomText("text"),
              20.ph,
              CustomGOEButton(
                  onPressed: () {
                    DownloadHandler.download(
                        downloadUrl:
                            "https://res.genupathlabs.com/genu_path_lab/live/customer_V2/sample_report/GlucoseFasting.pdf");
                  },
                  gradient: const LinearGradient(colors: [
                    ColorConst.red,
                    Colors.blue,
                  ]),
                  child: const CustomText("GlucoseFasting")),
              20.ph,
              CustomGOEButton(
                  onPressed: () {
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
                  gradient: const LinearGradient(colors: [
                    ColorConst.red,
                    Colors.blue,
                  ]),
                  child: const CustomText("download with header")),
              20.ph,
              CustomGOEButton(
                  onPressed: () async {
                    ForwardGeocoding? forwardGeocoding =
                        await Geocoding.forwardGeocoding(
                            address:
                                "Jot Bhim, New Town, Bidhannagar, North 24 Parganas District, West Bengal, 700160, India");
                    AppLog.i(forwardGeocoding?.longitude);
                  },
                  gradient: const LinearGradient(colors: [
                    ColorConst.red,
                    Colors.blue,
                  ]),
                  child: const CustomText(
                      "Jot Bhim, New Town, Bidhannagar, North 24 Parganas District, West Bengal, 700160, India")),
              20.ph,
              CustomGOEButton(
                  onPressed: () async {
                    ReverseGeocoding? reverseGeocoding =
                        await Geocoding.reverseGeocoding(
                            latitude: 22.5754, longitude: 88.4798);
                    AppLog.i(reverseGeocoding?.displayName);
                  },
                  gradient: const LinearGradient(colors: [
                    ColorConst.red,
                    Colors.blue,
                  ]),
                  child: const CustomText(
                      "Reverse Geocoding latitude: 22.5754, longitude: 88.4798")),
              20.ph,
              CustomGOEButton(
                  onPressed: () async {
                    String? deviceId = await AppConfig().getDeviceId();
                    AppLog.i(deviceId);
                    PopUpItems.toastMessage(deviceId ?? "", Colors.green);
                  },
                  gradient: const LinearGradient(colors: [
                    ColorConst.red,
                    Colors.blue,
                  ]),
                  child: const CustomText("Get Device Id")),
              20.ph,
              CustomGOEButton(
                  width: 200,
                  onPressed: () async {
                    kIsWeb
                        ? context.goNamed(RouteName.leaderBoard)
                        : context.pushNamed(RouteName.leaderBoard);
                  },
                  gradient: const LinearGradient(colors: [
                    ColorConst.red,
                    Colors.blue,
                  ]),
                  child: const CustomText("Navigate to leaderBoard")),
              20.ph,
              CustomGOEButton(
                  width: 200,
                  onPressed: () async {
                    CustomFile? customFile =
                        await CustomFilePicker.customFilePicker();
                    AppLog.i(customFile?.name, tag: "CustomFile");
                  },
                  gradient: const LinearGradient(colors: [
                    ColorConst.red,
                    Colors.blue,
                  ]),
                  child: const CustomText("File Pick")),
              20.ph,
              CustomGOEButton(
                  width: 200,
                  onPressed: () async {
                    CustomRoute.pushNamed(
                        name: RouteName.rayzorPay,
                        arguments: RazorpayMerchantDetails());
                  },
                  gradient: const LinearGradient(colors: [
                    ColorConst.red,
                    Colors.blue,
                  ]),
                  child: const CustomText("Razorpay")),
              20.ph,
              CustomTextFormField(
                controller: _amountController,
                title: 'Amount',
              ),
              20.ph,
              CustomTextFormField(
                controller: _midController,
                title: 'MID',
              ),
              20.ph,
              CustomTextFormField(
                controller: _orderIdController,
                title: 'Order ID',
              ),
              20.ph,
              CustomTextFormField(
                title: 'Txn Token',
                controller: _txnTokenController,
              ),
              20.ph,
              CustomGOEButton(
                  width: 200,
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
                  backGroundColor: Colors.blue,
                  child: const CustomText("Paytm WebViewPaymentGateway",
                      color: Colors.white)),
              20.ph,
              CustomGOEButton(
                  width: 160,
                  onPressed: () async {
                    PopUpItems.customMsgDialog(
                        title: "Success",
                        content: "Thank you, transaction complete.",
                        type: DialogType.success);
                  },
                  backGroundColor: Colors.amber,
                  child: const CustomText(
                    "Show Success",
                    color: Colors.white,
                  )),
              20.ph,
              YoutubeVideoPlayer(
                videoUrl: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
                height: 200,
              ),
              20.ph,
              Row(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      PopUpItems.toastMessage(
                          "On Tap", ColorConst.baseHexColor);
                    },
                    child: CustomNetWorkImageView(
                      url: ApiUrlConst.testImgUrl(),
                      radius: 8,
                      height: 200,
                      width: 120,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  CustomNetWorkImageView(
                    url: "${ApiUrlConst.testImgUrl()}lfmbldmfbl",
                    radius: 8,
                    height: 100,
                    width: 120,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
              20.ph,
              Row(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomNetWorkImageView(
                    url: ApiUrlConst.testImgUrl(),
                    radius: 8,
                    height: 100,
                    width: 120,
                    fit: BoxFit.fill,
                  ),
                  CustomNetWorkImageView(
                    url:
                        "https://stage-cdn.aadharhealth.in/incom/app_images/1726653030_accessories.png",
                    radius: 8,
                    height: 100,
                    width: 120,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
              20.ph,
              CarouselSlider(
                radius: 8,
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
              20.ph,
              Row(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: CustomNetWorkImageView(
                      url: ApiUrlConst.testImgUrl(),
                      radius: 8,
                      height: ScreenUtils.nw() / 2,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Expanded(
                    child: CustomNetWorkImageView(
                      url: ApiUrlConst.testImgUrl(),
                      radius: 8,
                      height: ScreenUtils.nw() / 2,
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
              20.ph,
              CarouselSlider(
                radius: 8,
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
              20.ph,
              Row(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: CustomNetWorkImageView(
                      url: ApiUrlConst.testImgUrl(),
                      radius: 8,
                      height: ScreenUtils.nw() / 2,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Expanded(
                    child: CustomNetWorkImageView(
                      url: ApiUrlConst.testImgUrl(),
                      radius: 8,
                      height: ScreenUtils.nw() / 2,
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
              20.ph,
              CarouselSlider(
                radius: 8,
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
              20.ph,
              Row(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: CustomNetWorkImageView(
                      url: ApiUrlConst.testImgUrl(),
                      radius: 8,
                      height: ScreenUtils.nw() / 2,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Expanded(
                    child: CustomNetWorkImageView(
                      url: ApiUrlConst.testImgUrl(),
                      radius: 8,
                      height: ScreenUtils.nw() / 2,
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
              20.ph,
              CustomNetWorkImageView(
                url: ApiUrlConst.testImgUrl(
                    aspectRatio: ScreenUtils.nw() / (ScreenUtils.nw() / 2)),
                radius: 8,
                height: ScreenUtils.nw() / 2,
                fit: BoxFit.fill,
              ),
              20.ph,
            ],
          ),
        ),
      ],
    );
  }
}
