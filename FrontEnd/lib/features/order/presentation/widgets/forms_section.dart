import 'package:flutter/material.dart';

import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/extensions/logger_extension.dart';
import 'package:dbnus/shared/ui/molecules/dropdowns/custom_dropdown.dart';
import 'package:dbnus/shared/ui/atoms/inputs/custom_text_formfield.dart';

class FormsSection extends StatelessWidget {
  const FormsSection({super.key});

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
          const CustomTextFormField(fieldHeight: 200),
          16.ph,
          const CustomTextFormField(),
          16.ph,
          const CustomTextFormField(maxLines: 1),
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
}
