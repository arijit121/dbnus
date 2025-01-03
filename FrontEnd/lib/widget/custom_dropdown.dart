import 'package:dbnus/extension/spacing.dart';
import 'package:flutter/material.dart';

import '../const/color_const.dart';
import 'custom_text.dart';

class CustomDropDown<T> extends StatelessWidget {
  final T? selectedValue;
  final void Function(T?)? onChanged;
  final List<CustomDropDownModel<T>> items;

  const CustomDropDown({
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
          fontColor: ColorConst.primaryDark),
      onChanged: onChanged,
      items: List.generate(
          items.length,
          (index) => DropdownMenuItem<T>(
                value: items.elementAt(index).value,
                child: CustomText(items.elementAt(index).title ?? '',
                    color: ColorConst.primaryDark, size: 13),
              )),
    );
  }
}

class CustomDropdownMenuFormField<T> extends StatelessWidget {
  final List<CustomDropDownModel<T>> items;
  final void Function(T?)? onChanged;
  final String? hintText;
  final Widget? prefix, suffix;
  final T? value;
  final String? Function(T?)? validator;
  final AutovalidateMode? autoValidateMode;
  final Widget? label;
  final BorderRadius borderRadius;

  const CustomDropdownMenuFormField({
    super.key,
    required this.onChanged,
    required this.items,
    this.hintText,
    this.prefix,
    this.suffix,
    this.value,
    this.validator,
    this.autoValidateMode = AutovalidateMode.onUserInteraction,
    this.label,
    this.borderRadius = const BorderRadius.all(Radius.circular(6.0)),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return _DropdownMenuFormField<T?>(
          label: label,
          validator: validator,
          autovalidateMode: autoValidateMode,
          width: constraints.maxWidth,
          menuStyle: const MenuStyle(
            backgroundColor: WidgetStatePropertyAll<Color>(Colors.white),
          ),
          initialSelection: value,
          leadingIcon: prefix,
          trailingIcon: suffix ??
              Icon(Icons.arrow_drop_down,
                  size: 24, color: ColorConst.primaryDark),
          selectedTrailingIcon: suffix != null
              ? RotatedBox(
                  quarterTurns: 2,
                  child: suffix,
                )
              : Icon(Icons.arrow_drop_up,
                  size: 24, color: ColorConst.primaryDark),
          hintText: hintText,
          textStyle: customizeTextStyle(
              fontColor: ColorConst.primaryDark, fontSize: 16),
          onSelected: onChanged,
          dropdownMenuEntries: List.generate(
              items.length,
              (index) => DropdownMenuEntry<T?>(
                  value: items.elementAt(index).value,
                  label: items.elementAt(index).title ?? "",
                  labelWidget: CustomText(
                    items.elementAt(index).title ?? "",
                    color: ColorConst.primaryDark,
                    size: 16,
                    fontWeight: FontWeight.w500,
                  ))),
          inputDecorationTheme: InputDecorationTheme(
            errorStyle: customizeTextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                fontColor: ColorConst.red),
            hintStyle:
                customizeTextStyle(fontColor: ColorConst.redGrey, fontSize: 16),
            labelStyle: customizeTextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                fontColor: ColorConst.blueGrey),
            floatingLabelStyle: customizeTextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                fontColor: ColorConst.primaryDark),
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
                color: ColorConst.grey,
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
                color: ColorConst.red,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: const BorderSide(
                color: ColorConst.red,
                width: 1,
              ),
            ),
          ));
    });
  }
}

class _DropdownMenuFormField<T> extends FormField<T> {
  _DropdownMenuFormField({
    super.key,
    bool enabled = true,
    double? width,
    double? menuHeight,
    Widget? leadingIcon,
    Widget? trailingIcon,
    Widget? label,
    String? hintText,
    String? helperText,
    Widget? selectedTrailingIcon,
    bool enableFilter = false,
    bool enableSearch = true,
    TextStyle? textStyle,
    InputDecorationTheme? inputDecorationTheme,
    MenuStyle? menuStyle,
    this.controller,
    T? initialSelection,
    this.onSelected,
    bool? requestFocusOnTap,
    EdgeInsets? expandedInsets,
    required List<DropdownMenuEntry<T>> dropdownMenuEntries,
    super.autovalidateMode = AutovalidateMode.disabled,
    super.validator,
  }) : super(
            initialValue: initialSelection,
            builder: (FormFieldState<T> field) {
              final _DropdownMenuFormFieldState<T> state =
                  field as _DropdownMenuFormFieldState<T>;
              void onSelectedHandler(T? value) {
                field.didChange(value);
                onSelected?.call(value);
              }

              return DropdownMenu<T>(
                key: key,
                enabled: enabled,
                width: width,
                menuHeight: menuHeight,
                leadingIcon: leadingIcon,
                trailingIcon: trailingIcon,
                label: label,
                hintText: hintText,
                helperText: helperText,
                errorText: state.errorText,
                selectedTrailingIcon: selectedTrailingIcon,
                enableFilter: enableFilter,
                enableSearch: enableSearch,
                textStyle: textStyle,
                inputDecorationTheme: inputDecorationTheme,
                menuStyle: menuStyle,
                controller: controller,
                initialSelection: state.value,
                onSelected: onSelectedHandler,
                requestFocusOnTap: requestFocusOnTap,
                expandedInsets: expandedInsets,
                dropdownMenuEntries: dropdownMenuEntries,
              );
            });

  final ValueChanged<T?>? onSelected;

  final TextEditingController? controller;

  @override
  FormFieldState<T> createState() => _DropdownMenuFormFieldState<T>();
}

class _DropdownMenuFormFieldState<T> extends FormFieldState<T> {
  _DropdownMenuFormField<T> get _dropdownMenuFormField =>
      widget as _DropdownMenuFormField<T>;

  @override
  void didChange(T? value) {
    super.didChange(value);
    // _dropdownMenuFormField.onSelected!(value);
  }

  @override
  void didUpdateWidget(_DropdownMenuFormField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      setValue(widget.initialValue);
    }
  }

  @override
  void reset() {
    super.reset();
    _dropdownMenuFormField.onSelected!(value);
  }
}

class CustomDropDownFormField<T> extends StatelessWidget {
  final void Function(T?)? onChanged;
  final List<CustomDropDownModel<T>> items;
  final String? hintText;
  final String? Function(T?)? validator;
  final T? value;
  final Widget? prefix, suffix;
  final Widget? label;
  final BorderRadius borderRadius;

  const CustomDropDownFormField({
    super.key,
    required this.onChanged,
    required this.items,
    this.hintText,
    this.validator,
    this.value,
    this.prefix,
    this.suffix,
    this.label,
    this.borderRadius = const BorderRadius.all(Radius.circular(6.0)),
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      isExpanded: true,
      dropdownColor: Colors.white,
      value: value,
      items: List.generate(
          items.length,
          (index) => DropdownMenuItem<T>(
                value: items.elementAt(index).value,
                child: CustomText(items.elementAt(index).title ?? '',
                    color: ColorConst.primaryDark, size: 13),
              )),
      onChanged: onChanged,
      hint: hintText != null
          ? CustomText(hintText!, color: ColorConst.grey, size: 13)
          : null,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      icon: 0.pw,
      decoration: InputDecoration(
        prefixIcon: prefix,
        suffixIcon: suffix ??
            Icon(Icons.arrow_drop_down,
                size: 24, color: ColorConst.primaryDark),
        label: label,
        contentPadding: const EdgeInsets.only(left: 8),
        hintStyle: customizeTextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            fontColor: ColorConst.blueGrey),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(
            color: ColorConst.blueGrey,
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: const BorderSide(
            color: ColorConst.red,
            width: 1,
          ),
        ),
      ),
    );
  }
}

class CustomDropDownModel<T> {
  T? value;
  String? title;

  CustomDropDownModel({this.value, this.title});
}

class CustomMenuAnchor<T> extends StatelessWidget {
  final void Function(T?) onPressed;
  final Widget child;
  final List<CustomDropDownModel<T>> items;

  const CustomMenuAnchor({
    super.key,
    required this.onPressed,
    required this.child,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        menuTheme: const MenuThemeData(
          style: MenuStyle(
              backgroundColor: WidgetStatePropertyAll<Color>(Colors.white)),
        ),
      ),
      child: MenuAnchor(
        style: MenuStyle(
          backgroundColor: WidgetStateProperty.all(
              Colors.white), // Set background color to white
        ),
        builder: (BuildContext context, MenuController controller, Widget? _) {
          return InkWell(
            onTap: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
            child: child,
          );
        },
        menuChildren: List<MenuItemButton>.generate(
          items.length,
          (int index) => MenuItemButton(
            onPressed: () {
              onPressed(items.elementAt(index).value);
            },
            child: CustomText(items.elementAt(index).title ?? "",
                color: ColorConst.primaryDark, size: 13),
          ),
        ),
      ),
    );
  }
}
