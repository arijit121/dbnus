import 'package:dbnus/extension/spacing.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../const/color_const.dart';
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

class UiTemp extends StatefulWidget {
  const UiTemp({super.key});

  @override
  State<UiTemp> createState() => _UiTempState();
}

class _UiTempState extends State<UiTemp> {
  TextEditingController _pinController = TextEditingController();
  final ValueNotifier<bool> boolNotifier = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return ListView(
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
        20.ph,
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
        20.ph,
        CustomGOEButton(
            onPressed: () async {
              await JsProvider().changeUrl(path: "/test");
            },
            gradient: const LinearGradient(colors: [
              Colors.red,
              Colors.blue,
            ]),
            child: const CustomText("Change Url")),
        20.ph,
        CustomGOEButton(
            size: const Size(160, 36),
            onPressed: () async {},
            gradient: const LinearGradient(colors: [
              Colors.red,
              Colors.blue,
            ]),
            child: const CustomText("Check")),
        20.ph,
        CustomGOEButton(
            size: const Size(160, 36),
            onPressed: () {
              boolNotifier.value = true;
              _pinController.text = "55555";
            },
            borderColor: Colors.amber,
            child: const CustomText(
              "Put 55555 in otp.",
              color: Colors.amber,
            )),
        ValueListenableBuilder<bool>(
            valueListenable: boolNotifier,
            builder: (context, value, child) {
              return boolNotifier.value
                  ? Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CustomGOEButton(
                              size: const Size(160, 36),
                              onPressed: () {
                                _pinController.clear();
                                boolNotifier.value = false;
                              },
                              backGroundColor: Colors.amber,
                              child: const CustomText(
                                "Clear pin-code hide.",
                                color: Colors.white,
                              )),
                          20.ph,
                          PinCodeTextField(
                            textStyle: customizeTextStyle(
                                fontColor: ColorConst.primaryDark),
                            cursorColor: Colors.black,
                            scrollPadding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom +
                                        140),
                            autoFocus: true,
                            appContext: context,
                            length: 5,
                            blinkWhenObscuring: true,
                            animationType: AnimationType.fade,
                            animationDuration:
                                const Duration(milliseconds: 300),
                            enableActiveFill: true,
                            autoDisposeControllers: false,
                            controller: _pinController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(4),
                              fieldHeight: 50,
                              fieldWidth: 46,
                              activeFillColor: Colors.grey.shade100,
                              inactiveFillColor: Colors.grey.shade100,
                              selectedFillColor: Colors.grey.shade100,
                              activeColor: Colors.transparent,
                              inactiveColor: Colors.transparent,
                              selectedColor: Colors.blue,
                            ),
                            backgroundColor: Colors.transparent,
                            onCompleted: (value) {
                              AppLog.i(_pinController.text);
                            },
                          ),
                        ],
                      )
                      // PinCodeTextField(
                      //   length: 5,
                      //   appContext: context,
                      //   autoDisposeControllers: false,
                      //   controller: controller,
                      //   onCompleted: (_) {
                      //     AppLog.i(controller.text);
                      //   },
                      // ),
                      )
                  : 0.ph;
            }),
        20.ph,
        CustomGOEButton(
            size: const Size(160, 36),
            onPressed: () async {
              PopUpItems().customMsgDialog(
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
        const CustomTextFormField(),
        20.ph,
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
        20.ph,
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
        20.ph,
        CustomIconButton(
            color: Colors.black,
            icon: Icon(Icons.map),
            onPressed: () {
              OpenService()
                  .openAddressInMap(address: 'Kolkata', direction: true);
            }),
        20.ph,
        CustomIconButton(
            color: Colors.black,
            icon: Icon(Icons.map),
            onPressed: () {
              OpenService().openCoordinatesInMap(
                latitude: 22.5354273,
                longitude: 88.3473527,
              );
            }),
        20.ph,
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
        20.ph,
        CustomGOEButton(
            size: const Size(200, 36),
            onPressed: () async {
              kIsWeb
                  ? context.goNamed(RouteName.games)
                  : context.pushNamed(RouteName.games);
            },
            gradient: const LinearGradient(colors: [
              Colors.red,
              Colors.blue,
            ]),
            child: const CustomText("Navigate to products")),
        20.ph,
        CustomIconButton(
            color: Colors.black,
            icon: Icon(Icons.add_box),
            onPressed: () {
              PopUpItems()
                  .toastMessage("Show tost msg..", ColorConst.primaryDark);
            }),
      ],
    );
  }
}
