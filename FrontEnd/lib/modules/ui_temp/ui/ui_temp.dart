import 'package:dbnus/extension/spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../const/color_const.dart';
import '../../../extension/hex_color.dart';
import '../../../extension/logger_extension.dart';
import '../../../router/custom_router/custom_route.dart';
import '../../../router/router_name.dart';
import '../../../service/JsService/provider/js_provider.dart';
import '../../../service/download_handler.dart';
import '../../../service/open_service.dart';
import '../../../utils/pop_up_items.dart';
import '../../../widget/custom_button.dart';
import '../../../widget/custom_dropdown.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/custom_text_formfield.dart';

class UiTemp extends StatelessWidget {
  const UiTemp({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomGOEButton(
          child: const CustomText("text"),
          onPressed: () {},
        ),
        20.ph,
        CustomGOEButton(
            onPressed: () {
              DownloadHandler().download(
                  url:
                      "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf");
            },
            gradient: const LinearGradient(colors: [
              Colors.red,
              Colors.blue,
            ]),
            child: const CustomText("Download")),
        CustomGOEButton(
            onPressed: () async {
              String? value = await JsProvider()
                  .loadJsAndPassValueWithCallbackAsync(
                      value: "testvdshvhfvsfhvs");
              AppLog.i(value);
            },
            gradient: const LinearGradient(colors: [
              Colors.red,
              Colors.blue,
            ]),
            child: const CustomText("loadJsAndPassValueWithCallbackAsync")),
        CustomGOEButton(
            onPressed: () async {
              await JsProvider().changeUrl(path: "/test");
            },
            gradient: const LinearGradient(colors: [
              Colors.red,
              Colors.blue,
            ]),
            child: const CustomText("Change Url")),
        const CustomTextFormField(),
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
        CustomMenuAnchor<String>(
          // hintText: "Please choose val",
          // suffix: const Icon(Icons.keyboard_arrow_down_rounded),
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
        CustomIconButton(
            color: Colors.black,
            icon: Icon(Icons.map),
            onPressed: () {
              OpenService()
                  .openAddressInMap(address: 'Kolkata', direction: true);
            }),
        CustomIconButton(
            color: Colors.black,
            icon: Icon(Icons.map),
            onPressed: () {
              OpenService().openCoordinatesInMap(
                latitude: 22.5354273,
                longitude: 88.3473527,
              );
            }),
        CustomGOEButton(
            size: const Size(200, 36),
            onPressed: () async {
              CustomRoute().clearAndNavigate(RouteName.leaderBoard);
            },
            gradient: const LinearGradient(colors: [
              Colors.red,
              Colors.blue,
            ]),
            child: const CustomText("Clear And Navigate to leaderBoard")),
        CustomGOEButton(
            onPressed: () async {
              context.pushNamed(RouteName.products);
            },
            gradient: const LinearGradient(colors: [
              Colors.red,
              Colors.blue,
            ]),
            child: const CustomText("Navigate to products")),
        CustomIconButton(
            color: Colors.black,
            icon: Icon(Icons.add_box),
            onPressed: () {
              PopUpItems().toastMessage(
                  "Show tost msg..", HexColor.fromHex(ColorConst.primaryDark));
            }),
      ],
    );
  }
}
