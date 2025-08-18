import 'dart:io';

import 'package:dbnus/service/value_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../const/color_const.dart';
import '../extension/color_exe.dart';
import '../service/JsService/provider/js_provider.dart' deferred as js_provider;
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
  final TextInputAction? textInputAction;
  final double? fieldHeight;

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
    this.maxLines,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.autofocus = false,
    this.textAlign,
    this.errorText,
    this.borderRadius = const BorderRadius.all(Radius.circular(6.0)),
    this.textInputAction = TextInputAction.done,
    this.fieldHeight,
  }) : assert(
          fieldHeight == null || maxLines == null,
          'maxLines must be null when fieldHeight is not null or zero.',
        );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title?.isNotEmpty == true)
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: CustomText('${title ?? ""}${isRequired == true ? " *" : ""}',
                color: ColorConst.primaryDark,
                size: 14,
                fontWeight: FontWeight.w400),
          ),
        SizedBox(
          height: ValueHandler.isNonZeroNumericValue(fieldHeight)
              ? fieldHeight
              : null,
          child: TextFormField(
              textInputAction: textInputAction,
              autofocus: autofocus,
              cursorColor: ColorConst.primaryDark,
              cursorErrorColor: ColorConst.primaryDark,
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
              minLines:
                  ValueHandler.isNonZeroNumericValue(fieldHeight) ? null : 1,
              expands: ValueHandler.isNonZeroNumericValue(fieldHeight)
                  ? true
                  : false,
              textAlign: textAlign ?? TextAlign.start,
              style: customizeTextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  fontColor: ColorConst.primaryDark),
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
                    fontColor: ColorConst.red),
                hintStyle: customizeTextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    fontColor: ColorConst.blueGrey),
                labelStyle: customizeTextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    fontColor: ColorConst.blueGrey),
                floatingLabelStyle: customizeTextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 17,
                    fontColor: ColorConst.baseHexColor),
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
              )),
        ),
      ],
    );
  }
}

/// A customizable pin code input widget with separate fields for each digit.
///
/// This widget displays a row of `TextField`s for entering a fixed-length pin code,
/// typically used for OTP (One-Time Password) or verification codes.
///
/// It provides built-in support for:
/// - Obscuring input characters
/// - Pasting directly from the clipboard (if full code is pasted)
/// - Styling based on states (active, error, completed)
/// - Handling auto focus navigation
/// - Notifying when input is complete
/// - Testing via a hidden TextField (for `tester.enterText`)
///
/// Example usage:
///
/// ```dart
/// final controller = TextEditingController();
///
/// PinCodeFormField(
///   length: 6,
///   controller: controller,
///   onCompleted: (code) {
///     print("Entered code: $code");
///   },
/// )
/// ```
class PinCodeFormField extends StatefulWidget {
  /// Total number of digits to input. Default is 6.
  final int length;

  /// The shared controller to get/set the full pin code value.
  ///
  /// If not provided, an internal controller is created and managed.
  final TextEditingController? controller;

  /// Callback triggered when all fields are filled.
  final void Function(String)? onCompleted;

  /// Border radius for each digit box.
  final BorderRadius? borderRadius;

  /// Whether the input fields are enabled.
  final bool enabled;

  /// Whether the input fields are [autoFocus] default false.
  final bool autoFocus;

  /// Whether the input characters should be obscured (e.g., for passwords or OTPs).
  final bool obscureText;

  /// Character used to obscure text when [obscureText] is true.
  final String obscuringCharacter;

  /// Keyboard type for input. Defaults to `TextInputType.number`.
  final TextInputType? keyboardType;

  /// Optional input formatters for the digit fields.
  ///
  /// Defaults to allowing digits only.
  final List<TextInputFormatter>? inputFormatters;

  /// A unique key for internal testing purposes (used in hidden TextField).
  final Key? uniqueKey;

  /// ScrollPadding follows the same property as TextField's ScrollPadding, default to const EdgeInsets.all(20),
  final EdgeInsets scrollPadding;

  /// Default [fieldWidth] is 46.
  final double fieldWidth;

  /// Custom border for each digit field.
  final InputBorder? border;

  /// Whether to fill the background of the input fields.
  final bool? filled;

  /// Whether to enable auto fill.
  final bool? autoFill;

  const PinCodeFormField({
    super.key,
    this.length = 6,
    this.controller,
    this.onCompleted,
    this.borderRadius,
    this.enabled = true,
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.keyboardType = TextInputType.number,
    this.inputFormatters,
    this.uniqueKey,
    this.autoFocus = false,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.fieldWidth = 46,
    this.border,
    this.filled,
    this.autoFill,
  });

  @override
  State<PinCodeFormField> createState() => _PinCodeFormFieldState();
}

class _PinCodeFormFieldState extends State<PinCodeFormField> {
  late final List<TextEditingController> _fieldControllers;
  late final List<FocusNode> _focusNodes;
  late final TextEditingController _mainController;

  bool _hasError = false;
  bool _hasCompleted = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    _fieldControllers =
        List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
    _mainController = widget.controller ?? TextEditingController();

    _mainController.addListener(_syncFromMainController);
    _autofill();
    // Listen for paste on first box
    /*_focusNodes[0].addListener(() async {
      if (_hasCompleted) return;
      if (_focusNodes[0].hasFocus) {
        final data = await Clipboard.getData('text/plain');
        final pasted = data?.text?.replaceAll(RegExp(r'\D'), '') ?? '';
        if (pasted.length == widget.length) {
          for (int i = 0; i < widget.length; i++) {
            _fieldControllers[i].text = pasted[i];
          }
          _mainController.text = pasted;
          setState(() {
            _hasCompleted = true;
            _hasError = false;
          });
          if (_fieldControllers.lastOrNull?.text.length == 1) {
            widget.onCompleted?.call(pasted);
          }
        }
      }
    });*/
  }

  @override
  void dispose() {
    _mainController.removeListener(_syncFromMainController);
    if (widget.controller == null) {
      _mainController.dispose();
    }
    for (final controller in _fieldControllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _syncFromMainController() {
    final text = _mainController.text;
    _pasted(text);
  }

  void _onChanged(String value, int index) {
    if (value.length == widget.length) {
      _pasted(value);
      return;
    }
    if (value.length == 2 && index == widget.length - 1) {
      _fieldControllers[index].text = value[1];
      _requestFocus(index);
    } else if (value.length == 1 && index == widget.length - 1) {
      _requestFocus(index);
    } else if (value.length == 1 && index < widget.length - 1) {
      _requestFocus(index + 1);
    } else if (value.isEmpty && index > 0) {
      _requestFocus(index - 1);
    }

    final pin = _fieldControllers.map((c) => c.text).join();
    _mainController.text = pin;

    pin.replaceAll(" ", "");
    if (pin.length == widget.length) {
      setState(() {
        _hasCompleted = true;
        _hasError = false;
      });
      widget.onCompleted?.call(pin);
    }
  }

  void _requestFocus(int index) {
    _focusNodes.elementAt(index).requestFocus();
    Future.microtask(() {
      _fieldControllers.elementAt(index).selection = TextSelection.collapsed(
          offset: _fieldControllers.elementAt(index).text.length);
    });
  }

  /// Clears all digits and resets state
  void clear() {
    for (final controller in _fieldControllers) {
      controller.clear();
    }
    _mainController.clear();
    _focusNodes[0].requestFocus();
    setState(() {
      _hasCompleted = false;
      _hasError = false;
    });
  }

  /// Shows error style
  void markError() {
    setState(() {
      _hasError = true;
      _hasCompleted = false;
    });
  }

  String _extractKeyName(Key? key) {
    if (key is ValueKey<String>) {
      return key.value;
    }
    return key?.toString() ?? 'pin_code_form_field';
  }

  Future<void> _autofill() async {
    if (widget.autoFill == true) {
      /// Clear the clipboard Web
      if (kIsWeb) {
        await Clipboard.setData(const ClipboardData(text: ''));
      }

      /// Auto Fill From Copy
      for (int i = 0; i < widget.length; i++) {
        if (_hasCompleted) return;
        if (_focusNodes[i].hasFocus) {
          final data = await Clipboard.getData('text/plain');
          final pasted = data?.text?.replaceAll(RegExp(r'\D'), '') ?? '';
          if (pasted.length == widget.length) {
            _pasted(pasted);
          }
        }
      }

      if (kIsWeb) {
        await js_provider.loadLibrary();
        final pasted = await js_provider.JsProvider().getWebOtp();
        if (pasted?.length == widget.length) {
          _pasted(pasted!);
        }
      } else if (Platform.isAndroid) {
        SmsAutoFill().listenForCode();
        SmsAutoFill().code.listen((pasted) {
          if (pasted.length == widget.length) {
            _pasted(pasted);
          }
          SmsAutoFill().unregisterListener();
        });
      }
    }
  }

  Future<void> _pasted(String pasted) async {
    for (int j = 0; j < widget.length; j++) {
      _fieldControllers[j].text = j < pasted.length ? pasted[j] : '';
    }
    if (pasted != _mainController.text) {
      _mainController.text = pasted;
    }
    int lastIndex = pasted.length - 1;
    lastIndex = lastIndex < 0 ? 0 : lastIndex;
    _requestFocus(lastIndex);
    if (pasted.length == widget.length) {
      setState(() {
        _hasCompleted = true;
        _hasError = false;
      });
      widget.onCompleted?.call(pasted);
    } else {
      setState(() {
        _hasCompleted = false;
        _hasError = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = ColorConst.lineGrey;
    final activeColor = ColorConst.lightBlue;
    final errorColor = ColorConst.red;
    final enabledColor =
        widget.enabled ? ColorConst.primaryDark : ColorConst.secondaryDark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 8,
      children: List.generate(widget.length, (index) {
        final isFilled = _fieldControllers[index].text.isNotEmpty;
        final color = _hasError
            ? errorColor
            : _hasCompleted && isFilled
                ? activeColor
                : baseColor;
        InputBorder? border = widget.border;
        if (border != InputBorder.none && border != null) {
          if (border is OutlineInputBorder) {
            border = border.copyWith(
              borderSide: BorderSide(color: color, width: 1),
              borderRadius: widget.borderRadius,
            );
          } else if (border is UnderlineInputBorder) {
            border = border.copyWith(
                borderSide: BorderSide(color: color, width: 1),
                borderRadius: widget.borderRadius);
          } else {
            border = border.copyWith(
              borderSide: BorderSide(color: color, width: 1),
            );
          }
        }

        return SizedBox(
          width: widget.fieldWidth,
          child: Semantics(
            label: "${_extractKeyName(widget.uniqueKey)}_$index",
            child: TextField(
              key: Key("${_extractKeyName(widget.uniqueKey)}_$index"),
              cursorColor: ColorConst.primaryDark,
              cursorErrorColor: ColorConst.primaryDark,
              autofocus: index == 0 ? widget.autoFocus : false,
              scrollPadding: widget.scrollPadding,
              enabled: widget.enabled,
              controller: _fieldControllers[index],
              focusNode: _focusNodes[index],
              textAlign: TextAlign.center,
              keyboardType: widget.keyboardType,
              inputFormatters: widget.inputFormatters ??
                  [FilteringTextInputFormatter.digitsOnly],
              maxLength: widget.length,
              obscureText: widget.obscureText,
              obscuringCharacter: widget.obscuringCharacter,
              style: customizeTextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 16,
                fontColor: enabledColor,
              ),
              decoration: InputDecoration(
                counterText: '',
                filled: widget.filled,
                fillColor: ColorExe.lighten(baseColor),
                border: border != InputBorder.none
                    ? border
                    : OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: widget.borderRadius ?? BorderRadius.zero),
              ),
              onChanged: (value) => _onChanged(value, index),
              autofillHints: widget.autoFill == true
                  ? const [AutofillHints.oneTimeCode]
                  : [],
              maxLines: 1,
            ),
          ),
        );
      }),
    );
  }
}
