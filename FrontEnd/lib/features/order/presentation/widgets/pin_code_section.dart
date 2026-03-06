import 'package:flutter/material.dart';

import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/extensions/logger_extension.dart';
import 'package:dbnus/shared/ui/atoms/buttons/custom_button.dart';
import 'package:dbnus/shared/ui/atoms/inputs/custom_text_formfield.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';

class PinCodeSection extends StatelessWidget {
  const PinCodeSection({
    super.key,
    required this.pinController,
    required this.boolNotifier,
    required this.clearPin,
  });

  final TextEditingController pinController;
  final ValueNotifier<bool> boolNotifier;
  final ValueNotifier<bool> clearPin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
                            if (pinController.text.isNotEmpty) {
                              pinController.clear();
                              clearPin.value = false;
                            }
                          },
                          gradient: const LinearGradient(colors: [
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
                                if (pinController.text.isNotEmpty) {
                                  pinController.clear();
                                  clearPin.value = false;
                                } else {
                                  pinController.text = "55554";
                                  clearPin.value = true;
                                }
                              },
                              gradient: const LinearGradient(colors: [
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
                          : const SizedBox.shrink();
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
                          controller: pinController,
                          length: 5,
                          autoFocus: true,
                          autoFill: true,
                          onCompleted: (value) {
                            AppLog.i(pinController.text, tag: "OnCompleted");
                          },
                        ))
                    : const SizedBox.shrink();
              }),
        ],
      ),
    );
  }
}
