import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:dbnus/shared/constants/assects_const.dart';
import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/logger_extension.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/core/services/context_service.dart';
import 'package:dbnus/core/services/value_handler.dart';
import 'package:dbnus/shared/utils/screen_utils.dart';
import 'package:dbnus/shared/utils/text_utils.dart';
import 'package:dbnus/shared/utils/validator.dart';
import 'package:dbnus/shared/ui/atoms/buttons/custom_button.dart';
import 'package:dbnus/shared/ui/atoms/images/custom_image.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:dbnus/shared/ui/atoms/inputs/custom_text_formfield.dart';

class PopUpItems {
  static void toastMessage(String message, Color color,
      {int? durationSeconds,
      ScaffoldMessengerState? scaffoldState,
      EdgeInsetsGeometry? padding}) {
    SnackBar snackBar = SnackBar(
      duration: Duration(seconds: durationSeconds ?? 2),
      content: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: ToastMassage(
          message: message,
          color: color,
        ),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(5),
    );
    ScaffoldMessengerState scaffoldMessengerState =
        scaffoldState ?? ScaffoldMessenger.of(CurrentContext().context);
    scaffoldMessengerState.showSnackBar(snackBar);
  }

  static Future<DateTime?> buildMaterialDatePicker(
      {DateTime? initDate, DateTime? startDate, DateTime? endDate}) async {
    final DateTime? picked = await showDatePicker(
      context: CurrentContext().context,
      initialDate: initDate ?? DateTime.now(),
      firstDate: startDate ?? DateTime(1900),
      lastDate: endDate ?? DateTime(DateTime.now().year + 20),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDatePickerMode: DatePickerMode.day,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(),
          child: child!,
        );
      },
    );
    AppLog.i('buildMaterialDatePicker $picked');
    return picked;
  }

  static Future<String?> emailPicker() {
    return Navigator.of(CurrentContext().context).push(
      PageRouteBuilder(
          opaque: false, pageBuilder: (_, __, ___) => const EmailPicker()),
    );
  }

  static Future<void> cupertinoPopup({
    String? title,
    void Function()? cancelBtnPresses,
    void Function()? okBtnPressed,
    String? content,
    String? cancelBtnText,
    String? okBtnText,
  }) async {
    String? result = await showCupertinoDialog<String>(
      context: CurrentContext().context,
      barrierDismissible: true,
      builder: (BuildContext context) => CupertinoTheme(
        data: const CupertinoThemeData(brightness: Brightness.light),
        child: CupertinoAlertDialog(
          title: title != null ? CustomText(title, size: 14) : null,
          content: content != null
              ? ValueHandler.isHtml(content)
                  ? CustomHtmlText(content,
                      color: ColorConst.primaryDark, size: 14)
                  : CustomText(content, color: ColorConst.primaryDark, size: 14)
              : null,
          actions: <Widget>[
            if (cancelBtnPresses != null)
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: CustomText(cancelBtnText ?? "Cancel",
                    color: ColorConst.primaryDark, size: 14),
              ),
            if (okBtnPressed != null)
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context, "Yes");
                },
                child: CustomText(okBtnText ?? "Ok",
                    color: ColorConst.primaryDark, size: 14),
              ),
          ],
        ),
      ),
    );
    if (result == "Yes") {
      if (okBtnPressed != null) {
        okBtnPressed();
      }
    } else {
      if (cancelBtnPresses != null) {
        cancelBtnPresses();
      }
    }
  }

  static Future<void> materialPopup({
    String? title,
    required void Function()? cancelBtnPresses,
    required void Function()? okBtnPressed,
    String? content,
    String? cancelBtnText,
    String? okBtnText,
  }) async {
    String? result = await showDialog<String>(
      context: CurrentContext().context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (ValueHandler.isTextNotEmptyOrNull(title)) ...[
              CustomTextEnum(
                title!,
                color: ColorConst.primaryDark,
                styleType: CustomTextStyleType.subHeading1,
              ),
              8.ph,
            ],
            if (ValueHandler.isTextNotEmptyOrNull(content)) ...[
              Flexible(
                child: SingleChildScrollView(
                  child: ValueHandler.isHtml(content!)
                      ? CustomHtmlText(content,
                          color: ColorConst.primaryDark, size: 14)
                      : CustomText(
                          content,
                          color: ColorConst.primaryDark,
                          size: 14,
                        ),
                ),
              ),
            ],
            24.ph,
            CustomGOEButton(
              radius: 8,
              width: double.infinity,
              height: 44,
              backGroundColor: ColorConst.primaryDark,
              onPressed: () {
                Navigator.pop(context, "Yes");
              },
              child: CustomTextEnum(
                okBtnText ?? "Ok",
                color: Colors.white,
                styleType: CustomTextStyleType.body1,
              ),
            ),
            if (cancelBtnPresses != null) ...[
              12.ph,
              CustomGOEButton(
                borderColor: ColorConst.lineGrey,
                radius: 8,
                width: double.infinity,
                height: 42,
                backGroundColor: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: CustomTextEnum(cancelBtnText ?? "Cancel",
                    color: ColorConst.primaryDark,
                    styleType: CustomTextStyleType.body1),
              )
            ],
          ],
        ),
      ),
    );
    if (result == "Yes") {
      if (okBtnPressed != null) {
        okBtnPressed();
      }
    } else {
      if (cancelBtnPresses != null) {
        cancelBtnPresses();
      }
    }
  }

  static Future<void> customMsgDialog(
      {String? title,
      String? content,
      DialogType? type,
      CrossAxisAlignment contentCrossAxisAlignment =
          CrossAxisAlignment.center}) async {
    Widget? icon;
    Color? iconButtonColor;
    if (type != null) {
      switch (type) {
        case DialogType.success:
          iconButtonColor = Colors.green;
          icon = Icon(Icons.check_circle, color: iconButtonColor, size: 48);
          break;
        case DialogType.error:
          iconButtonColor = Colors.red;
          icon = Icon(Icons.error, color: iconButtonColor, size: 48);
          break;
        case DialogType.warning:
          iconButtonColor = Colors.amber;
          icon = Icon(Icons.warning, color: iconButtonColor, size: 48);
          break;
        case DialogType.info:
          iconButtonColor = Colors.blue;
          icon = Icon(Icons.info, color: iconButtonColor, size: 48);
          break;
      }
    }

    await showDialog<String>(
      context: CurrentContext().context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: contentCrossAxisAlignment,
          children: [
            if (icon != null) ...[
              icon,
              if (content != null || title != null) 16.ph,
            ],
            if (ValueHandler.isTextNotEmptyOrNull(title)) ...[
              CustomTextEnum(
                title!,
                color: ColorConst.primaryDark,
                styleType: CustomTextStyleType.subHeading1,
              ),
              if (content != null) 8.ph,
            ],
            if (content != null)
              Flexible(
                child: SingleChildScrollView(
                  child: ValueHandler.isHtml(content)
                      ? CustomHtmlText(content,
                          color: ColorConst.primaryDark, size: 14)
                      : CustomText(content,
                          color: ColorConst.primaryDark,
                          size: 14,
                          textAlign: TextAlign.start),
                ),
              ),
            24.ph,
            CustomGOEButton(
              radius: 8,
              width: double.infinity,
              height: 44,
              backGroundColor: iconButtonColor ?? Colors.blueAccent,
              onPressed: () {
                Navigator.pop(context);
              },
              child: CustomTextEnum(
                TextUtils.ok,
                color: Colors.white,
                styleType: CustomTextStyleType.body1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Enum for dialog types
enum DialogType { success, error, warning, info }

class ToastMassage extends StatelessWidget {
  const ToastMassage({super.key, required this.message, required this.color});

  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 20,
        shadowColor: ColorConst.grey,
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: CustomAssetImageView(
                    path: AssetsConst.dbnusNoImageLogo,
                    height: 24,
                    width: 24,
                    color: ColorConst.deepBlue,
                  )),
              10.pw,
              SizedBox(
                width: ScreenUtils.aw() * 0.5,
                child: CustomText(message,
                    color: Colors.white, size: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ));
  }
}

class EmailPicker extends StatefulWidget {
  const EmailPicker({super.key});

  @override
  State<EmailPicker> createState() => _EmailPickerState();
}

class _EmailPickerState extends State<EmailPicker> {
  final key = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.primaryDark.withOpacity(0.26),
      body: Form(
        key: key,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: ColorConst.baseHexColor,
                    blurRadius: 7,
                    spreadRadius: 3,
                  )
                ],
              ),
              padding: const EdgeInsets.only(
                  top: 20, left: 10, right: 10, bottom: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                      child: CustomTextFormField(
                          title: TextUtils.email,
                          hintText: TextUtils.enter_email,
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: Validator.emailValidator)),
                  10.ph,
                  CustomGOEButton(
                      width: 80,
                      radius: 10,
                      backGroundColor: Colors.blueAccent,
                      child: CustomText(TextUtils.ok,
                          color: Colors.white, size: 20),
                      onPressed: () {
                        if (key.currentState?.validate() == true) {
                          Navigator.pop(context, emailController.text.trim());
                        }
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
