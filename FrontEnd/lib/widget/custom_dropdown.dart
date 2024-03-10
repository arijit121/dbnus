import 'package:flutter/material.dart';

import '../const/color_const.dart';
import '../extension/hex_color.dart';
import 'custom_text.dart';

Widget customMenuDropDown<T>(
        {T? selectedValue,
        required void Function(T?)? onChanged,
        required List<DropdownMenuItem<T>>? items}) =>
    DropdownButton<T>(
      value: selectedValue,
      icon: const Icon(Icons.arrow_drop_down),
      underline: Container(
        height: 2,
        color: Colors.transparent,
      ),
      elevation: 1,
      style: customizeTextStyle(
          fontWeight: FontWeight.w400, fontSize: 16, fontColor: HexColor.fromHex(ColorConst.primaryDark)),
      onChanged: onChanged,
      items: items,
    );

Widget customDropDownFormField<T>(
        {required void Function(T?)? onChanged,
        required List<DropdownMenuItem<T>>? items,
        String? hintText,
        String? Function(T?)? validator,
        T? value}) =>
    DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      hint: hintText != null ? customText(hintText,color:  Colors.grey,size:  13) : null,
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

List<DropdownMenuItem<T>> customItemList<T>({
  required List<CustomDropDownModel<T>> valueList,
}) =>
    List.generate(
        valueList.length,
        (index) => DropdownMenuItem<T>(
              value: valueList.elementAt(index).value,
              child: customText(
                  valueList.elementAt(index).title ?? '',color:  HexColor.fromHex(ColorConst.primaryDark),size:  13),
            ));

class CustomDropDownModel<T> {
  T? value;
  String? title;

  CustomDropDownModel({this.value, this.title});
}

Widget customMenuAnchor<T>(
        {required void Function(T?) onPressed,
        required Widget icon,
        required List<CustomDropDownModel<T>> items,
        double? iconSize,
        Color? color}) =>
    MenuAnchor(
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
          child:
              customText(items.elementAt(index).title ?? "",color:  HexColor.fromHex(ColorConst.primaryDark),size:  13),
        ),
      ),
    );
