import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import '../../constants/theme.dart';

class CustomInput extends StatelessComponent {
  final String? placeholder;
  final String? value;
  final void Function(String)? onChanged;
  final String? type;
  final String? className;

  const CustomInput({
    this.placeholder,
    this.value,
    this.onChanged,
    this.type,
    this.className,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return input<String>(
      classes: 'custom-input ${className ?? ""}'.trim(),
      type: type != null
          ? InputType.values.firstWhere((e) => e.name == type,
              orElse: () => InputType.text)
          : InputType.text,
      value: value,
      attributes: {
        if (placeholder != null) 'placeholder': placeholder!,
      },
      onInput: onChanged,
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.custom-input', [
      css('&').styles(
        width: 100.percent,
        padding: .symmetric(horizontal: 16.px, vertical: 12.px),
        radius: .all(.circular(10.px)),
        border: Border.all(color: lightGrey, width: 1.5.px),
        fontSize: 14.px,
        color: primaryDark,
        backgroundColor: Colors.white,
        raw: {'outline': 'none', 'transition': 'border-color 0.2s ease'},
      ),
      css('&:focus').styles(
        border: Border.all(color: baseHexColor, width: 1.5.px),
      ),
      css('&::placeholder').styles(color: grey),
    ]),
  ];
}
