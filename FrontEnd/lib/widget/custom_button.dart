import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../const/color_const.dart';
import '../data/model/service_model.dart';
import '../extension/color_exe.dart';
import '../service/redirect_engine.dart';
import '../storage/localCart/bloc/local_cart_bloc.dart';
import '../storage/localCart/model/cart_service_model.dart';
import '../storage/localCart/repo/local_cart_repo.dart';
import '../utils/text_utils.dart';
import '../widget/custom_text.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton(
      {super.key,
      required this.child,
      required this.onPressed,
      this.color,
      this.padding});

  final Widget child;
  final void Function()? onPressed;
  final Color? color;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
          foregroundColor: color,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 4.0),
        ),
        onPressed: onPressed,
        child: child);
  }
}

///The CustomIconButton is a versatile and customizable icon button widget in Flutter. Here’s a brief explanation of its variables:
/// [icon]
/// The icon to display inside the button. Allows the caller to pass a custom icon.
/// [color]The color of the icon. Enables the customization of the icon's color.
/// [backgroundColor]
/// The background color of the button. Allows the button to have a custom background color.
/// [iconSize]
/// The size of the icon. Lets the caller specify the size of the icon.
/// [onPressed]
/// The callback function that is triggered when the button is pressed. Ensures that the button has the necessary functionality.
/// [padding]
/// The padding around the icon inside the button. Allows for custom padding to be applied.
class CustomIconButton extends StatelessWidget {
  const CustomIconButton(
      {super.key,
      required this.icon,
      this.color,
      this.backgroundColor,
      this.iconSize,
      required this.onPressed,
      this.padding});

  final Widget icon;
  final Color? color, backgroundColor;
  final double? iconSize;
  final void Function()? onPressed;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: backgroundColor,
          ),
          padding: padding ?? const EdgeInsets.all(4.0),
          child: IconTheme.merge(
            data: IconThemeData(
              size: iconSize,
              color: color,
            ),
            child: icon,
          ),
        ),
      ),
    );
  }
}

/// Gradient Outline Evaluator Button ([CustomGOEButton] Button)
///
/// The [CustomGOEButton] Button combines modern design with functional interactivity. Key features include:
/// Gradient: Smooth color transitions for a dynamic look.
/// Outline: Sharp, defined borders for enhanced visibility.
/// Evaluator: Built-in functionality for actions, calculations, or validations.
/// Perfect for web pages, mobile apps, or software interfaces, the GOE Button elevates user experience with its stylish and practical design.
/// [onPressed]
/// Callback function triggered when the button is pressed.
/// [child]
/// Content of the button, typically a Text or Icon widget.
/// [borderColor]
/// Specifies the color of the button's border (optional).
/// [backGroundColor]
/// Sets the background color of the button (optional, overridden by gradient if provided).
/// [radius]
/// Defines the corner radius of the button (defaults to 16 if not specified).
/// [size]
/// Sets the minimum width and height of the button (defaults to Size(88, 36)).
/// [gradient]
/// Applies a gradient background to the button (optional, overrides backGroundColor).
/// [padding]
/// Specifies the internal padding of the button's content (defaults to EdgeInsets.symmetric(horizontal: 16)).
class CustomGOEButton extends StatelessWidget {
  const CustomGOEButton(
      {super.key,
      required this.onPressed,
      required this.child,
      this.borderColor,
      this.backGroundColor,
      this.radius,
      this.width = 88,
      this.height = 36,
      this.gradient,
      this.padding,
      this.boxShadow});

  final void Function()? onPressed;
  final Widget child;
  final Color? borderColor;
  final Color? backGroundColor;
  final double? radius, width, height;

  final Gradient? gradient;
  final EdgeInsetsGeometry? padding;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    // Determine the effective background color and gradient when disabled
    final Color? effectiveBackgroundColor =
        onPressed == null && (backGroundColor != null || gradient != null)
            ? Colors.grey.shade200 // Disabled background color
            : backGroundColor;
    final Gradient? effectiveGradient = onPressed == null ? null : gradient;

    final Color? effectiveBorderColor = onPressed == null && borderColor != null
        ? Colors.grey.shade400 // Disabled border color
        : borderColor;

    // Determine splash, highlight, and hover colors based on background or gradient
    Color? sHlHColor = effectiveGradient != null
        ? ColorExe.mixColors(effectiveGradient.colors)?.withOpacity(0.3)
        : effectiveBackgroundColor ?? effectiveBorderColor?.withOpacity(0.075);

    final Color? splashColor =
        sHlHColor != null ? ColorExe.darken(sHlHColor, 0.05) : null;
    final Color? highlightColor =
        sHlHColor != null ? ColorExe.darken(sHlHColor, 0.0125) : null;
    final Color? hoverColor =
        sHlHColor != null ? ColorExe.darken(sHlHColor, 0.025) : null;

    final double? effectiveHeight =
        borderColor != null && (height ?? 0) > 2 ? (height ?? 0) - 2 : height;

    final double? effectiveWidth =
        borderColor != null && (width ?? 0) > 2 ? (width ?? 0) - 2 : width;

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          gradient: effectiveGradient,
          borderRadius: BorderRadius.circular(radius ?? 16),
          color: effectiveGradient == null ? effectiveBackgroundColor : null,
          border: effectiveBorderColor != null
              ? Border.all(
                  color: effectiveBorderColor,
                )
              : null,
        ),
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 16),
          ),
          onTap: onPressed,
          // Disable onTap if disabled
          splashColor: splashColor,
          highlightColor: highlightColor,
          hoverColor: hoverColor,
          child: Container(
            height: effectiveHeight,
            width: effectiveWidth,
            alignment: Alignment.center,
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(boxShadow: boxShadow),
            child: child,
          ),
        ),
      ),
    );
  }
}

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({
    super.key,
    required this.value,
    this.isRounded,
    this.activeColor,
    required this.onChanged,
  });

  final bool? value, isRounded;
  final void Function(bool?)? onChanged;
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      checkColor: Colors.white,
      activeColor: activeColor ?? Colors.blue,
      value: value,
      shape: isRounded == true
          ? const CircleBorder()
          : RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      onChanged: onChanged,
      visualDensity: const VisualDensity(
          horizontal: VisualDensity.minimumDensity,
          vertical: VisualDensity.minimumDensity),
    );
  }
}

class CustomRadioButton<T> extends StatelessWidget {
  const CustomRadioButton(
      {super.key,
      required this.value,
      required this.groupValue,
      required this.onChanged,
      this.activeColor});

  final T value;
  final T? groupValue;
  final void Function(T?)? onChanged;
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    return Radio<T>(
      fillColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return activeColor ?? Colors.blue;
          }
          return ColorConst.grey;
        },
      ),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      visualDensity: const VisualDensity(
          horizontal: VisualDensity.minimumDensity,
          vertical: VisualDensity.minimumDensity),
    );
  }
}

Widget customCartButton(
        {ServiceModel? serviceModel,
        String? redirectUrl,
        bool? fullLengthDisableMsg}) =>
    BlocBuilder<LocalCartBloc, LocalCartState>(
      builder: (context, state) {
        return Container(
          child: LocalCartRepo.instance.checkIfServiceContainInCart(
                  allServiceList: state.serviceList.value ?? [],
                  serviceId: "${serviceModel?.serviceId}")
              ? CustomGOEButton(
                  onPressed: () {
                    context.read<LocalCartBloc>().add(RemoveServiceFromCart(
                        serviceId: serviceModel?.serviceId ?? ""));
                  },
                  backGroundColor: ColorConst.red,
                  radius: 5,
                  child: CustomText(TextUtils.remove,
                      color: Colors.white,
                      size: 14,
                      fontWeight: FontWeight.w700))
              : LocalCartRepo.instance.checkIfPackageServiceContainInCart(
                      allServiceList: state.serviceList.value ?? [],
                      serviceModel: serviceModel)
                  ? Container()
                  : CustomGOEButton(
                      onPressed: () {
                        context.read<LocalCartBloc>().add(AddServiceToCart(
                            serviceModel: CartServiceModel(
                                serviceId: serviceModel?.serviceId ?? "",
                                price: serviceModel?.offerFees ??
                                    serviceModel?.fees ??
                                    0.0,
                                listOfPackageService: LocalCartRepo.instance
                                    .getAssociatedService(
                                        serviceModel: serviceModel)
                                    .map((e) => CartPackageService(
                                        serviceId: e.serviceId))
                                    .toList())));
                        if (redirectUrl != null) {
                          RedirectEngine().redirectRoutes(
                              redirectUrl: Uri.parse(redirectUrl));
                        }
                      },
                      backGroundColor: ColorConst.green,
                      radius: 5,
                      child: CustomText(TextUtils.book_now,
                          color: Colors.white,
                          size: 14,
                          fontWeight: FontWeight.w700)),
        );
      },
    );
