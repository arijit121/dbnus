import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../const/color_const.dart';
import '../extension/hex_color.dart';
import '../extension/spacing.dart';
import '../widget/custom_text.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final String? title;
  final String? label;
  final bool? isRequired;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffix;
  final Widget? prefix;
  final int? maxLength;
  final void Function()? onTap;
  final bool? enabled;
  final bool readOnly;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;
  final void Function(String)? onFieldSubmitted;
  final int? maxLines;
  final EdgeInsets scrollPadding;
  final bool autofocus;
  final TextAlign? textAlign;
  final String? errorText;
  final BorderRadius borderRadius;

  const CustomTextFormField({
    super.key,
    this.controller,
    this.hintText,
    this.validator,
    this.title,
    this.label,
    this.isRequired,
    this.keyboardType,
    this.inputFormatters,
    this.suffix,
    this.prefix,
    this.maxLength,
    this.onTap,
    this.enabled,
    this.readOnly = false,
    this.onChanged,
    this.focusNode,
    this.onFieldSubmitted,
    this.maxLines = 1,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.autofocus = false,
    this.textAlign,
    this.errorText,
    this.borderRadius = const BorderRadius.all(Radius.circular(6.0)),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (title?.isNotEmpty == true)
          Row(
            children: [
              CustomText('${title ?? ""}${isRequired == true ? " *" : ""}',
                  color: HexColor.fromHex(ColorConst.primaryDark),
                  size: 14,
                  fontWeight: FontWeight.w400),
            ],
          ),
        if (title?.isNotEmpty == true) 5.ph,
        TextFormField(
            autofocus: autofocus,
            cursorColor: HexColor.fromHex(ColorConst.primaryDark),
            cursorErrorColor: HexColor.fromHex(ColorConst.primaryDark),
            onChanged: onChanged,
            readOnly: readOnly,
            controller: controller,
            validator: validator,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            maxLength: maxLength,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onTap: onTap,
            enabled: enabled,
            focusNode: focusNode,
            scrollPadding: scrollPadding,
            onFieldSubmitted: onFieldSubmitted,
            maxLines: maxLines,
            textAlign: textAlign ?? TextAlign.start,
            style: customizeTextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                fontColor: HexColor.fromHex(ColorConst.primaryDark)),
            decoration: InputDecoration(
              errorText: errorText,
              counterText: "",
              prefixIcon: prefix,
              suffixIcon: suffix,
              labelText: (label?.isNotEmpty == true)
                  ? '${label ?? ""}${isRequired == true ? " *" : ""}'
                  : null,
              hintText: hintText,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              errorStyle: customizeTextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  fontColor: Colors.red),
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
                borderRadius: borderRadius,
                borderSide: const BorderSide(
                  color: Colors.blue,
                  width: 1,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: const BorderSide(
                  color: Colors.white,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: BorderSide(
                  color: HexColor.fromHex(ColorConst.grey4),
                  width: 1,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: const BorderSide(
                  width: 1,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 1,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 1,
                ),
              ),
            )),
      ],
    );
  }
}
