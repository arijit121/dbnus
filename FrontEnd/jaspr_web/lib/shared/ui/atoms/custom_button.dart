import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import '../../constants/theme.dart';
import 'custom_text.dart';


class CustomTextButton extends StatelessComponent {
  final Component child;
  final void Function()? onPressed;
  final Color? color;
  final String? className;
  final Styles? style;

  const CustomTextButton({
    required this.child,
    required this.onPressed,
    this.color,
    this.className,
    this.style,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return button(
      classes: 'custom-text-btn ${className ?? ""}'.trim(),
      styles: Styles.combine([
        if (color != null) Styles(raw: {'color': color.toString()}),
        if (style != null) style!,
      ]),
      events: {'click': (e) => onPressed?.call()},
      [child],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.custom-text-btn', [
      css('&').styles(
        backgroundColor: Colors.transparent,
        border: .none,
        cursor: .pointer,
        fontSize: 14.px,
        fontWeight: .w600,
        padding: .symmetric(horizontal: 4.px, vertical: 8.px),
        raw: {
          'color': 'inherit',
          'outline': 'none',
          'transition': 'opacity 0.2s ease',
        },
      ),
      css('&:hover').styles(
        raw: {'opacity': '0.8'},
      ),
    ]),
  ];
}

class CustomIconButton extends StatelessComponent {
  final Component icon;
  final Color? color;
  final Color? backgroundColor;
  final double? iconSize;
  final void Function()? onPressed;
  final String? className;
  final Styles? style;

  const CustomIconButton({
    required this.icon,
    this.color,
    this.backgroundColor,
    this.iconSize,
    required this.onPressed,
    this.className,
    this.style,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return button(
      classes: 'custom-icon-btn ${className ?? ""}'.trim(),
      styles: Styles.combine([
        if (backgroundColor != null) Styles(raw: {'background-color': backgroundColor.toString()}),
        if (color != null) Styles(raw: {'color': color.toString()}),
        if (iconSize != null) Styles(raw: {'font-size': '${iconSize}px'}),
        if (style != null) style!,
      ]),
      events: {'click': (e) => onPressed?.call()},
      [icon],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.custom-icon-btn', [
      css('&').styles(
        display: .inlineFlex,
        alignItems: .center,
        justifyContent: .center,
        padding: .all(8.px),
        radius: .all(.circular(50.percent)),
        border: .none,
        cursor: .pointer,
        raw: {
          'background-color': 'transparent',
          'transition': 'background-color 0.2s ease, opacity 0.2s ease',
          'outline': 'none',
        },
      ),
      css('&:hover').styles(
        backgroundColor: const Color('#6C63FF15'),
      ),
      css('&:active').styles(
        raw: {'opacity': '0.7'},
      ),
    ]),
  ];
}

class CustomGOEButton extends StatelessComponent {
  final void Function()? onPressed;
  final Component child;
  final Color? borderColor;
  final Color? disableBorderColor;
  final Color? backGroundColor;
  final Color? disableBackGroundColor;
  final double? borderRadius;
  final double? width;
  final double? height;
  final List<Color>? gradientColors;
  final String? className;
  final Styles? style;

  const CustomGOEButton({
    required this.onPressed,
    required this.child,
    this.borderColor,
    this.disableBorderColor,
    this.backGroundColor,
    this.disableBackGroundColor,
    this.borderRadius,
    this.width,
    this.height,
    this.gradientColors,
    this.className,
    this.style,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    final isDisabled = onPressed == null;

    // Background styling
    Styles bgStyle;
    if (isDisabled) {
      final disabledBg = disableBackGroundColor ?? const Color('#cbd5e1'); // Slate 300
      bgStyle = Styles(raw: {'background-color': disabledBg.toString()});
    } else if (gradientColors != null && gradientColors!.isNotEmpty) {
      if (gradientColors!.length == 1) {
        bgStyle = Styles(raw: {'background-color': gradientColors!.first.toString()});
      } else {
        final colorStrs = gradientColors!.map((c) => c.toString()).join(', ');
        bgStyle = Styles(raw: {'background': 'linear-gradient(135deg, $colorStrs)'});
      }
    } else if (backGroundColor != null) {
      bgStyle = Styles(raw: {'background-color': backGroundColor.toString()});
    } else {
      bgStyle = Styles(raw: {'background-color': 'transparent'});
    }

    // Border styling
    Styles borderStyle;
    if (borderColor != null) {
      final borderCol = isDisabled ? (disableBorderColor ?? const Color('#cbd5e1')) : borderColor!;
      borderStyle = Styles(raw: {'border': '1px solid $borderCol'});
    } else {
      borderStyle = Styles(raw: {'border': 'none'});
    }

    final combinedStyles = Styles.combine([
      bgStyle,
      borderStyle,
      if (width != null) Styles(raw: {'width': '${width}px'}),
      if (height != null) Styles(raw: {'height': '${height}px'}),
      if (borderRadius != null) Styles(raw: {'border-radius': '${borderRadius}px'}),
      if (style != null) style!,
    ]);

    return button(
      classes: [
        'custom-goe-btn',
        if (isDisabled) 'disabled',
        if (className != null) className!,
      ].join(' ').trim(),
      styles: combinedStyles,
      events: isDisabled ? {} : {'click': (e) => onPressed?.call()},
      [child],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.custom-goe-btn', [
      css('&').styles(
        display: .inlineFlex,
        alignItems: .center,
        justifyContent: .center,
        padding: .symmetric(horizontal: 16.px, vertical: 8.px),
        radius: .all(.circular(16.px)),
        cursor: .pointer,
        transition: Transition('all', duration: Duration(milliseconds: 150)),
        raw: {
          'box-shadow': '0 4px 12px rgba(0, 0, 0, 0.1)',
          'outline': 'none',
        },
      ),
      css('&:hover:not(.disabled)').styles(
        raw: {
          'transform': 'scale(0.96)',
          'box-shadow': '0 2px 6px rgba(0, 0, 0, 0.08)',
        },
      ),
      css('&.disabled').styles(
        cursor: .notAllowed,
        raw: {'box-shadow': 'none', 'opacity': '0.6'},
      ),
    ]),
  ];
}

class CustomCheckbox extends StatelessComponent {
  final bool value;
  final bool isRounded;
  final Color? activeColor;
  final void Function(bool)? onChanged;
  final String? className;

  const CustomCheckbox({
    required this.value,
    this.isRounded = false,
    this.activeColor,
    required this.onChanged,
    this.className,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return input<bool>(
      type: InputType.checkbox,
      classes: [
        'custom-checkbox',
        if (isRounded) 'rounded',
        if (className != null) className!,
      ].join(' ').trim(),
      checked: value,
      styles: Styles.combine([
        if (activeColor != null) Styles(raw: {'--active-color': activeColor.toString()}),
      ]),
      onChange: onChanged,
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.custom-checkbox', [
      css('&').styles(
        width: 18.px,
        height: 18.px,
        cursor: .pointer,
        raw: {
          'appearance': 'none',
          '-webkit-appearance': 'none',
          'border': '2px solid #94a3b8',
          'border-radius': '4px',
          'outline': 'none',
          'transition': 'all 0.2s ease',
          'background-color': '#ffffff',
          'position': 'relative',
        },
      ),
      css('&.rounded').styles(
        raw: {'border-radius': '50%'},
      ),
      css('&:checked').styles(
        raw: {
          'background-color': 'var(--active-color, #3b82f6)',
          'border-color': 'var(--active-color, #3b82f6)',
        },
      ),
      css('&:checked::after').styles(
        raw: {
          'content': '""',
          'position': 'absolute',
          'left': '4.5px',
          'top': '1px',
          'width': '5px',
          'height': '10px',
          'border': 'solid white',
          'border-width': '0 2px 2px 0',
          'transform': 'rotate(45deg)',
        },
      ),
    ]),
  ];
}

class CustomRadioButton<T> extends StatelessComponent {
  final T value;
  final T? groupValue;
  final void Function(T?)? onChanged;
  final Color? activeColor;
  final Color? inActiveColor;
  final String? className;

  const CustomRadioButton({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.activeColor,
    this.inActiveColor,
    this.className,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    final isSelected = value == groupValue;
    return input<bool>(
      type: InputType.radio,
      classes: [
        'custom-radio-button',
        if (className != null) className!,
      ].join(' ').trim(),
      checked: isSelected,
      styles: Styles.combine([
        if (activeColor != null) Styles(raw: {'--active-color': activeColor.toString()}),
        if (inActiveColor != null) Styles(raw: {'--inactive-color': inActiveColor.toString()}),
      ]),
      onChange: (_) {
        if (onChanged != null) {
          onChanged!(value);
        }
      },
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.custom-radio-button', [
      css('&').styles(
        width: 18.px,
        height: 18.px,
        cursor: .pointer,
        raw: {
          'appearance': 'none',
          '-webkit-appearance': 'none',
          'border': '2px solid var(--inactive-color, #94a3b8)',
          'border-radius': '50%',
          'outline': 'none',
          'transition': 'all 0.2s ease',
          'background-color': '#ffffff',
          'position': 'relative',
        },
      ),
      css('&:checked').styles(
        raw: {
          'border-color': 'var(--active-color, #3b82f6)',
        },
      ),
      css('&:checked::after').styles(
        raw: {
          'content': '""',
          'position': 'absolute',
          'left': '3px',
          'top': '3px',
          'width': '8.5px',
          'height': '8.5px',
          'border-radius': '50%',
          'background-color': 'var(--active-color, #3b82f6)',
        },
      ),
    ]),
  ];
}

class CustomToggleSwitchButton extends StatelessComponent {
  final bool value;
  final void Function(bool)? onChanged;
  final Color? selectedTrackColor;
  final Color? defaultTrackColor;
  final Color? selectedThumbColor;
  final Color? defaultThumbColor;
  final Color? selectedBorderColor;
  final Color? defaultBorderColor;
  final String? className;

  const CustomToggleSwitchButton({
    required this.value,
    required this.onChanged,
    this.selectedTrackColor,
    this.defaultTrackColor,
    this.selectedThumbColor,
    this.defaultThumbColor,
    this.selectedBorderColor,
    this.defaultBorderColor,
    this.className,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes: [
        'custom-toggle-switch',
        if (value) 'active',
        if (className != null) className!,
      ].join(' ').trim(),
      styles: Styles.combine([
        if (selectedTrackColor != null) Styles(raw: {'--active-track-color': selectedTrackColor.toString()}),
        if (defaultTrackColor != null) Styles(raw: {'--inactive-track-color': defaultTrackColor.toString()}),
        if (selectedThumbColor != null) Styles(raw: {'--active-thumb-color': selectedThumbColor.toString()}),
        if (defaultThumbColor != null) Styles(raw: {'--inactive-thumb-color': defaultThumbColor.toString()}),
        if (selectedBorderColor != null) Styles(raw: {'--active-border-color': selectedBorderColor.toString()}),
        if (defaultBorderColor != null) Styles(raw: {'--inactive-border-color': defaultBorderColor.toString()}),
      ]),
      events: {
        'click': (e) {
          if (onChanged != null) {
            onChanged!(!value);
          }
        }
      },
      [
        div(classes: 'toggle-thumb', []),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.custom-toggle-switch', [
      css('&').styles(
        width: 44.px,
        height: 24.px,
        radius: .all(.circular(12.px)),
        cursor: .pointer,
        display: .inlineFlex,
        alignItems: .center,
        padding: .all(2.px),
        transition: Transition('all', duration: Duration(milliseconds: 200)),
        raw: {
          'background-color': 'var(--inactive-track-color, #cbd5e1)',
          'border': '1px solid var(--inactive-border-color, transparent)',
          'position': 'relative',
        },
      ),
      css('&.active').styles(
        raw: {
          'background-color': 'var(--active-track-color, #22c55e)',
          'border-color': 'var(--active-border-color, transparent)',
        },
      ),
      css('.toggle-thumb').styles(
        width: 18.px,
        height: 18.px,
        radius: .all(.circular(50.percent)),
        transition: Transition('all', duration: Duration(milliseconds: 200)),
        raw: {
          'background-color': 'var(--inactive-thumb-color, #ffffff)',
          'left': '2px',
          'position': 'absolute',
        },
      ),
      css('&.active .toggle-thumb').styles(
        raw: {
          'background-color': 'var(--active-thumb-color, #ffffff)',
          'left': '22px',
        },
      ),
    ]),
  ];
}

class CustomCartButton extends StatelessComponent {
  final bool isInCart;
  final bool isPackageInCart;
  final double? borderRadius;
  final void Function()? onAddPressed;
  final void Function()? onRemovePressed;

  const CustomCartButton({
    required this.isInCart,
    required this.isPackageInCart,
    this.borderRadius,
    this.onAddPressed,
    this.onRemovePressed,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    if (isInCart) {
      return CustomGOEButton(
        onPressed: onRemovePressed,
        backGroundColor: red,
        borderRadius: borderRadius ?? 5,
        child: const CustomText(
          'Remove',
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      );
    } else if (isPackageInCart) {
      return Component.empty();
    } else {
      return CustomGOEButton(
        onPressed: onAddPressed,
        backGroundColor: green,
        borderRadius: borderRadius ?? 5,
        child: const CustomText(
          'Book Now',
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      );
    }
  }
}
