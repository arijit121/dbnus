import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import '../../constants/color_const.dart';

class CustomDropDownModel<T> {
  final T? value;
  final String? title;

  const CustomDropDownModel({this.value, this.title});
}

class CustomDropDown<T> extends StatelessComponent {
  final T? selectedValue;
  final void Function(T?)? onChanged;
  final List<CustomDropDownModel<T>> items;
  final String? hintText;
  final String? className;
  final Styles? style;

  const CustomDropDown({
    required this.items,
    this.selectedValue,
    this.onChanged,
    this.hintText,
    this.className,
    this.style,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return select(
      classes: 'custom-dropdown ${className ?? ""}'.trim(),
      styles: Styles.combine([
        Styles(raw: {
          'padding': '10px 14px',
          'border': '1px solid ${ColorConst.lightGrey.value}',
          'border-radius': '8px',
          'background-color': '#FFFFFF',
          'color': ColorConst.primaryDark.value,
          'font-size': '14px',
          'outline': 'none',
          'cursor': 'pointer',
          'box-sizing': 'border-box',
          'width': '100%',
        }),
        if (style != null) style!,
      ]),
      onChange: (dynamic val) {
        if (onChanged != null) {
          final strVal = val is List ? (val.isNotEmpty ? val.first.toString() : null) : val?.toString();
          final found = items.where((item) => item.value.toString() == strVal);
          if (found.isNotEmpty) {
            onChanged!(found.first.value);
          } else {
            onChanged!(null);
          }
        }
      },
      [
        if (hintText != null)
          option(
            value: '',
            selected: selectedValue == null,
            disabled: true,
            [Component.text(hintText!)],
          ),
        for (final item in items)
          option(
            value: item.value.toString(),
            selected: item.value == selectedValue,
            [Component.text(item.title ?? item.value.toString())],
          ),
      ],
    );
  }
}
