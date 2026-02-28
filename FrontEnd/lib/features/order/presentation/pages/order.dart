import 'package:dbnus/core/models/custom_notification_model.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// import 'package:pin_code_fields/pin_code_fields.dart';

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
      children: [
        CustomGOEButton(
          child: const CustomText("text"),
          onPressed: () {},
        ),
        20.ph,
        CustomGOEButton(
            onPressed: () {
              DownloadHandler.download(
                  downloadUrl:
                      "https://file-examples.com/storage/fe6146b54768752f9a08cf7/2017/10/file-example_PDF_1MB.pdf");
            },
            backGroundColor: Colors.blue.shade300,
            child: const CustomText("Download")),
        20.ph,
        CustomGOEButton(
            onPressed: () async {
              notificationId =
                  await NotificationHandler.showUpdateFlutterNotification(
                CustomNotificationModel(
                  title: "Silent Notification4",
                  message: "test",
                  bigText:
                      "<p>This is<sub> subscript</sub> and <sup>superscript</sup></p>",
                  imageUrl: ApiUrlConst.testImgUrl(),
                  // actionURL: "http://localhost:6906/leader_board",
                  sound: "slow_spring_board",
                ),
              );
            },
            gradient: const LinearGradient(colors: [
              ColorConst.red,
              Colors.blue,
            ]),
            child: const CustomText("Show notification")),
        20.ph,
        CustomGOEButton(
            onPressed: () {
              NotificationHandler.showUpdateFlutterNotification(
                CustomNotificationModel(
                  title: "Silent Notification update",
                  message: "test ${notificationId}",
                  bigText:
                      "<p>This is<sub> subscript</sub> and <sup>superscript</sup></p>",
                  imageUrl: ApiUrlConst.testImgUrl(),
                  // actionURL: "http://localhost:6906/leader_board",
                  sound: "slow_spring_board",
                ),
                notificationId: notificationId,
              );
            },
            gradient: const LinearGradient(colors: [
              ColorConst.red,
              Colors.blue,
            ]),
            child: const CustomText("Update notification")),
        20.ph,
        CustomGOEButton(
            onPressed: () async {
              String? value =
                  await JsProvider.loadJsAndPassValueWithCallbackAsync(
                      value: "testvdshvhfvsfhvs");
              AppLog.i(value);
            },
            gradient: const LinearGradient(colors: [
              ColorConst.red,
              Colors.blue,
            ]),
            child: const CustomText("loadJsAndPassValueWithCallbackAsync")),
        20.ph,
        CustomGOEButton(
            onPressed: () async {
              await JsProvider.changeUrl(path: "/test");
            },
            gradient: const LinearGradient(colors: [
              ColorConst.red,
              Colors.blue,
            ]),
            child: const CustomText("Change Url")),
        20.ph,
        CustomGOEButton(
            width: 160,
            onPressed: () async {
              CustomFilePicker.customFilePicker();
            },
            gradient: const LinearGradient(colors: [
              ColorConst.red,
              Colors.blue,
            ]),
            child: const CustomText("File Picker")),
        20.ph,
        ValueListenableBuilder<bool>(
            valueListenable: boolNotifier,
            builder: (context, value, child) {
              return CustomGOEButton(
                  width: 160,
                  onPressed: () {
                    boolNotifier.value = !boolNotifier.value;
                    if (_pinController.text.isNotEmpty) {
                      _pinController.clear();
                      clearPin.value = false;
                    }
                  },
                  backGroundColor: Colors.amber,
                  child: CustomText(
                    "Pin-code ${boolNotifier.value ? 'hide' : 'show'}.",
                    color: Colors.white,
                  ));
            }),
        ValueListenableBuilder<bool>(
            valueListenable: boolNotifier,
            builder: (context, value, child) {
              return boolNotifier.value
                  ? Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: CustomGOEButton(
                          width: 160,
                          onPressed: () {
                            if (_pinController.text.isNotEmpty) {
                              _pinController.clear();
                              clearPin.value = false;
                            } else {
                              _pinController.text = "55554";
                              clearPin.value = true;
                            }
                          },
                          backGroundColor: Colors.amber,
                          child: ValueListenableBuilder<bool>(
                              valueListenable: clearPin,
                              builder: (context, value, child) {
                                return CustomText(
                                  "${clearPin.value ? 'Clear' : 'Put 55554'} pin-code .",
                                  color: Colors.white,
                                );
                              })))
                  : 0.ph;
            }),
        ValueListenableBuilder<bool>(
            valueListenable: boolNotifier,
            builder: (context, value, child) {
              return boolNotifier.value
                  ? Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: PinCodeFormField(
                        controller: _pinController,
                        length: 5,
                        autoFocus: true,
                        autoFill: true,
                        onCompleted: (value) {
                          AppLog.i(_pinController.text, tag: "OnCompleted");
                        },
                      )
                      /*PinCodeTextField(
                        textStyle: customizeTextStyle(
                            fontColor: ColorConst.primaryDark),
                        cursorColor: ColorConst.primaryDark,
                        scrollPadding: EdgeInsets.only(
                            bottom:
                                MediaQuery.of(context).viewInsets.bottom + 140),
                        autoFocus: true,
                        appContext: context,
                        length: 5,
                        blinkWhenObscuring: true,
                        animationType: AnimationType.fade,
                        animationDuration: const Duration(milliseconds: 300),
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
                      )*/
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
        CustomTextFormField(fieldHeight: 200),
        20.ph,
        CustomTextFormField(),
        20.ph,
        CustomTextFormField(maxLines: 1),
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
            color: ColorConst.primaryDark,
            icon: Icon(Icons.map),
            onPressed: () {
              OpenService.openAddressInMap(address: 'Kolkata', direction: true);
            }),
        20.ph,
        CustomIconButton(
            color: ColorConst.primaryDark,
            icon: Icon(Icons.map),
            onPressed: () {
              OpenService.openCoordinatesInMap(
                latitude: 22.5354273,
                longitude: 88.3473527,
              );
            }),
        20.ph,
        CustomGOEButton(
            width: 200,
            onPressed: () async {
              CustomRoute.clearAndNavigateName(RouteName.leaderBoard);
            },
            gradient: const LinearGradient(colors: [
              ColorConst.red,
              Colors.blue,
            ]),
            child: const CustomText("Clear And Navigate to leaderBoard")),
        20.ph,
        CustomGOEButton(
            width: 200,
            onPressed: () async {
              kIsWeb
                  ? context.goNamed(RouteName.games)
                  : context.pushNamed(RouteName.games);
            },
            gradient: const LinearGradient(colors: [
              ColorConst.red,
              Colors.blue,
            ]),
            child: const CustomText("Navigate to products")),
        20.ph,
        CustomIconButton(
            color: ColorConst.primaryDark,
            icon: Icon(Icons.add_box),
            onPressed: () {
              PopUpItems.toastMessage(
                  "Show tost msg..", ColorConst.primaryDark);
            }),
      ],
    );
  }
}
