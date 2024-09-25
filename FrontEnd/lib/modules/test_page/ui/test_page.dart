import 'package:dbnus/extension/spacing.dart';
import 'package:dbnus/router/router_name.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../config/app_config.dart';
import '../../../data/model/forward_geocoding.dart';
import '../../../data/model/reverse_geocoding.dart';
import '../../../extension/logger_extension.dart';
import '../../../service/download_handler.dart';
import '../../../service/geocoding.dart';
import '../../../widget/custom_button.dart';
import '../../../widget/custom_text.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            primary: false,
            children: [
              20.ph,
              CustomIconButton(icon: const Icon(Icons.abc), onPressed: () {}),
              20.ph,
              CustomGOEButton(
                child: const CustomText("text"),
                onPressed: () {},
              ),
              20.ph,
              CustomGOEButton(
                  onPressed: () {},
                  gradient: const LinearGradient(colors: [
                    Colors.red,
                    Colors.blue,
                  ]),
                  child: const CustomText("text")),
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
                    DownloadHandler().download(
                        url:
                            "https://res.genupathlabs.com/genu_path_lab/live/customer_V2/sample_report/GlucoseFasting.pdf");
                  },
                  gradient: const LinearGradient(colors: [
                    Colors.red,
                    Colors.blue,
                  ]),
                  child: const CustomText("GlucoseFasting")),
              20.ph,
              CustomGOEButton(
                  onPressed: () {
                    DownloadHandler().download(
                        url:
                            "https://res.genupathlabs.com/genu_path_lab/live/customer_V2/sample_report/GlucosePP.pdf");
                  },
                  gradient: const LinearGradient(colors: [
                    Colors.red,
                    Colors.blue,
                  ]),
                  child: const CustomText("GlucosePP")),
              20.ph,
              CustomGOEButton(
                  onPressed: () {
                    DownloadHandler().download(
                        url:
                            "https://res.genupathlabs.com/genu_path_lab/live/customer_V2/sample_report/LipidProfile.pdf");
                  },
                  gradient: const LinearGradient(colors: [
                    Colors.red,
                    Colors.blue,
                  ]),
                  child: const CustomText("LipidProfile")),
              20.ph,
              CustomGOEButton(
                  onPressed: () {
                    DownloadHandler().download(
                        url:
                            "https://storage.googleapis.com/approachcharts/test/5MB-test.ZIP");
                  },
                  gradient: const LinearGradient(colors: [
                    Colors.red,
                    Colors.blue,
                  ]),
                  child: const CustomText("5MB-test")),
              20.ph,
              CustomGOEButton(
                  onPressed: () async {
                    ForwardGeocoding? forwardGeocoding = await Geocoding()
                        .forwardGeocoding(
                            address:
                                "Jot Bhim, New Town, Bidhannagar, North 24 Parganas District, West Bengal, 700160, India");
                    AppLog.i(forwardGeocoding?.longitude);
                  },
                  gradient: const LinearGradient(colors: [
                    Colors.red,
                    Colors.blue,
                  ]),
                  child: const CustomText(
                      "Jot Bhim, New Town, Bidhannagar, North 24 Parganas District, West Bengal, 700160, India")),
              20.ph,
              CustomGOEButton(
                  onPressed: () async {
                    ReverseGeocoding? reverseGeocoding = await Geocoding()
                        .reverseGeocoding(
                            latitude: 22.5754, longitude: 88.4798);
                    AppLog.i(reverseGeocoding?.displayName);
                  },
                  gradient: const LinearGradient(colors: [
                    Colors.red,
                    Colors.blue,
                  ]),
                  child: const CustomText(
                      "Reverse Geocoding latitude: 22.5754, longitude: 88.4798")),
              20.ph,
              CustomGOEButton(
                  onPressed: () async {
                    String? deviceId = await AppConfig().getDeviceId();
                    AppLog.i(deviceId);
                  },
                  gradient: const LinearGradient(colors: [
                    Colors.red,
                    Colors.blue,
                  ]),
                  child: const CustomText("Get Device Id")),
              20.ph,
              CustomGOEButton(
                  size: const Size(200, 36),
                  onPressed: () async {
                    kIsWeb
                        ? context.goNamed(RouteName.leaderBoard)
                        : context.pushNamed(RouteName.leaderBoard);
                  },
                  gradient: const LinearGradient(colors: [
                    Colors.red,
                    Colors.blue,
                  ]),
                  child: const CustomText("Navigate to leaderBoard")),
              20.ph,
            ],
          ),
        ),
      ],
    );
  }
}
