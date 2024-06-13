import 'package:flutter/material.dart';

import '../const/color_const.dart';
import '../extension/hex_color.dart';
import 'custom_text.dart';

class CustomMenuDropDown<T> extends StatelessWidget {
  final T? selectedValue;
  final void Function(T?)? onChanged;
  final List<DropdownMenuItem<T>>? items;

  const CustomMenuDropDown({
    super.key,
    this.selectedValue,
    required this.onChanged,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
      value: selectedValue,
      icon: const Icon(Icons.arrow_drop_down),
      underline: Container(
        height: 2,
        color: Colors.transparent,
      ),
      elevation: 1,
      style: customizeTextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          fontColor: HexColor.fromHex(ColorConst.primaryDark)),
      onChanged: onChanged,
      items: items,
    );
  }
}

class CustomDropDownFormField<T> extends StatelessWidget {
  final void Function(T?)? onChanged;
  final List<DropdownMenuItem<T>>? items;
  final String? hintText;
  final String? Function(T?)? validator;
  final T? value;

  const CustomDropDownFormField({
    super.key,
    required this.onChanged,
    required this.items,
    this.hintText,
    this.validator,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      hint: hintText != null
          ? CustomText(hintText!, color: Colors.grey, size: 13)
          : null,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 8),
        hintStyle: customizeTextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            fontColor: HexColor.fromHex(ColorConst.color5)),
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
      ),
    );
  }
}

List<DropdownMenuItem<T>> customItemList<T>({
  required List<CustomDropDownModel<T>> valueList,
}) =>
    List.generate(
        valueList.length,
            (index) => DropdownMenuItem<T>(
          value: valueList.elementAt(index).value,
          child: CustomText(valueList.elementAt(index).title ?? '',
              color: HexColor.fromHex(ColorConst.primaryDark), size: 13),
        ));

class CustomDropDownModel<T> {
  T? value;
  String? title;

  CustomDropDownModel({this.value, this.title});
}

class CustomMenuAnchor<T> extends StatelessWidget {
  final void Function(T?) onPressed;
  final Widget icon;
  final List<CustomDropDownModel<T>> items;
  final double? iconSize;
  final Color? color;

  const CustomMenuAnchor({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.items,
    this.iconSize,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
        return IconButton(
          iconSize: iconSize,
          color: color,
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: icon,
        );
      },
      menuChildren: List<MenuItemButton>.generate(
        items.length,
            (int index) => MenuItemButton(
          onPressed: () {
            onPressed(items.elementAt(index).value);
          },
          child: CustomText(items.elementAt(index).title ?? "",
              color: HexColor.fromHex(ColorConst.primaryDark), size: 13),
        ),
      ),
    );
  }
}