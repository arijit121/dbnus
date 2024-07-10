import 'package:flutter/material.dart';
import '../extension/spacing.dart';
import '../utils/screen_utils.dart';
import '../utils/text_utils.dart';
import '../utils/validator.dart';

import '../const/assects_const.dart';
import '../const/color_const.dart';
import '../extension/hex_color.dart';
import '../extension/logger_extension.dart';
import '../service/context_service.dart';
import '../widget/custom_button.dart';
import '../widget/custom_image.dart';
import '../widget/custom_text.dart';
import '../widget/custom_text_formfield.dart';

class PopUpItems {
  void toastMessage(String message, Color color, {int? durationSeconds}) {
    SnackBar snackBar = SnackBar(
      duration: Duration(seconds: durationSeconds ?? 2),
      content: ToastMassage(
        message: message,
        color: color,
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(5),
    );
    ScaffoldMessenger.of(CurrentContext().context).showSnackBar(snackBar);
  }

  Future<DateTime?> buildMaterialDatePicker(
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

  Future<String?> emailPicker() {
    return Navigator.of(CurrentContext().context).push(
      PageRouteBuilder(
          opaque: false, pageBuilder: (_, __, ___) => const EmailPicker()),
    );
  }

  void customMsgDialog({required String msg, String? content}) {
    showDialog<String>(
      context: CurrentContext().context,
      builder: (BuildContext context) => AlertDialog(
        title: CustomText(msg,
            color: HexColor.fromHex(ColorConst.primaryDark),
            size: 13,
            textAlign: TextAlign.start),
        content: content != null
            ? CustomText(content,
                color: HexColor.fromHex(ColorConst.primaryDark),
                size: 12,
                textAlign: TextAlign.start)
            : null,
        actions: <Widget>[
          CustomGOEButton(
            radius: 10,
            backGroundColor: Colors.blueAccent,
            onPressed: () {
              Navigator.pop(context);
            },
            child: CustomText(TextUtils.ok, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}

//ignore: must_be_immutable
class ToastMassage extends StatelessWidget {
  ToastMassage({super.key, required this.message, required this.color});

  String message;
  Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 20,
        shadowColor: Colors.grey,
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: CustomAssetImageView(
                    path: AssetsConst.genuIcon,
                    height: 40,
                    width: 40,
                    color: HexColor.fromHex(ColorConst.deepBlue),
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
      backgroundColor:
          HexColor.fromHex(ColorConst.primaryDark).withOpacity(0.26),
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
                    color: HexColor.fromHex(ColorConst.baseHexColor),
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
                          validator: Validator().emailValidator)),
                  10.ph,
                  CustomGOEButton(
                      minimumSize: const Size(80, 35),
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
