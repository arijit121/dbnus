import 'package:flutter/material.dart';

import '../const/color_const.dart';
import '../extension/hex_color.dart';
import 'custom_text.dart';

// ignore: must_be_immutable
class CustomMenuDropDown<T> extends StatelessWidget {
  CustomMenuDropDown(
      {super.key,
      this.selectedValue,
      required this.onChanged,
      required this.items});
  T? selectedValue;
  void Function(T?)? onChanged;
  List<DropdownMenuItem<T>>? items;
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

// ignore: must_be_immutable
class CustomDropDownFormField<T> extends StatelessWidget {
  CustomDropDownFormField(
      {super.key,
      required this.onChanged,
      required this.items,
      this.hintText,
      this.validator,
      this.value});
  void Function(T?)? onChanged;
  List<DropdownMenuItem<T>>? items;
  String? hintText;
  String? Function(T?)? validator;
  T? value;
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
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

// ignore: must_be_immutable
class CustomMenuAnchor<T> extends StatelessWidget {
  CustomMenuAnchor(
      {super.key,
      required this.onPressed,
      required this.icon,
      required this.items,
      this.iconSize,
      this.color});
  void Function(T?) onPressed;
  Widget icon;
  List<CustomDropDownModel<T>> items;
  double? iconSize;
  Color? color;
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
