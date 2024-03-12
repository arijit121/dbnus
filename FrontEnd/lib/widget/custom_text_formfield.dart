import 'package:flutter/material.dart';
import 'package:genu/extension/hex_color.dart';
import 'package:genu/extension/spacing.dart';
import 'package:genu/widget/custom_text.dart';

import '../const/color_const.dart';

Widget customTextFormField(
        {TextEditingController? controller,
        String? hintText,
        String? Function(String?)? validator,
        String? title,
        String? label,
        bool? isRequired,
        TextInputType? keyboardType,
        Widget? suffix,
        Widget? prefix,
        int? maxLength,
        void Function()? onTap,
        bool? enabled,
        bool readOnly = false,
        void Function(String)? onChanged,
        FocusNode? focusNode,
        void Function(String)? onFieldSubmitted,
        EdgeInsets scrollPadding = const EdgeInsets.all(20.0)}) =>
    Column(
      children: [
        if (title?.isNotEmpty == true)
          Row(
            children: [
              customText('${title ?? ""}${isRequired == true ? " *" : ""}',
                  color: HexColor.fromHex(ColorConst.primaryDark),
                  size: 14,
                  fontWeight: FontWeight.w500),
            ],
          ),
        if (title?.isNotEmpty == true) 5.ph,
        TextFormField(
            cursorColor: HexColor.fromHex(ColorConst.primaryDark),
            // cursorErrorColor: HexColor.fromHex(ColorConst.primaryDark),
            onChanged: onChanged,
            readOnly: readOnly,
            controller: controller,
            validator: validator,
            keyboardType: keyboardType,
            maxLength: maxLength,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onTap: onTap,
            enabled: enabled,
            focusNode: focusNode,
            scrollPadding: scrollPadding,
            onFieldSubmitted: onFieldSubmitted,
            decoration: InputDecoration(
              counterText: "",
              prefixIcon: prefix,
              suffixIcon: suffix,
              labelText: (label?.isNotEmpty == true)
                  ? '${label ?? ""}${isRequired == true ? " *" : ""}'
                  : null,
              hintText: hintText,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              hintStyle: customizeTextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  fontColor: HexColor.fromHex(ColorConst.color5)),
              labelStyle: customizeTextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  fontColor: HexColor.fromHex(ColorConst.color5)),
              floatingLabelStyle: customizeTextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 17,
                  fontColor: HexColor.fromHex(ColorConst.baseHexColor)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9.0),
                borderSide: const BorderSide(
                  color: Colors.blue,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9.0),
                borderSide: BorderSide(
                  color: HexColor.fromHex(ColorConst.color5),
                  width: 1,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9.0),
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 1,
                ),
              ),
            )),
      ],
    );
