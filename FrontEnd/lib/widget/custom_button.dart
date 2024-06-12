import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widget/custom_text.dart';

import '../const/color_const.dart';
import '../data/model/service_model.dart';
import '../extension/hex_color.dart';
import '../service/redirect_engine.dart';
import '../storage/localCart/bloc/local_cart_bloc.dart';
import '../storage/localCart/model/cart_service_model.dart';
import '../storage/localCart/repo/local_cart_repo.dart';
import '../utils/text_utils.dart';

// ignore: must_be_immutable
class CustomElevatedButton extends StatelessWidget {
  CustomElevatedButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.color,
    this.minimumSize,
    this.radius,
    this.gradient,
    this.padding,
  });

  Widget child;
  void Function()? onPressed;
  Color? color;
  Size? minimumSize = const Size(88, 36);
  double? radius;
  Gradient? gradient;
  EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return gradient != null
        ? DecoratedBox(
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.all(Radius.circular(radius ?? 16)),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                minimumSize: minimumSize,
                padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(radius ?? 16)),
                ),
              ),
              onPressed: onPressed,
              child: child,
            ),
          )
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              surfaceTintColor: Colors.transparent,
              minimumSize: minimumSize,
              padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
              shape: radius != null
                  ? RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(radius!),
                    )
                  : null,
            ),
            onPressed: onPressed,
            child: child,
          );
  }
}

// ignore: must_be_immutable
class CustomTextButton extends StatelessWidget {
  CustomTextButton(
      {super.key,
      required this.child,
      required this.onPressed,
      this.color,
      this.padding});

  Widget child;
  void Function()? onPressed;
  Color? color;
  EdgeInsetsGeometry? padding;

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
    return backgroundColor != null
        ? IconButton.filled(
            icon: icon,
            color: color,
            onPressed: onPressed,
            constraints: const BoxConstraints(),
            style: IconButton.styleFrom(
              padding: padding ?? const EdgeInsets.all(4.0),
              backgroundColor: backgroundColor,
              iconSize: iconSize,
            ))
        : IconButton(
            icon: icon,
            color: color,
            onPressed: onPressed,
            constraints: const BoxConstraints(),
            style: IconButton.styleFrom(
              padding: padding ?? const EdgeInsets.all(4.0),
              iconSize: iconSize,
            ));
  }
}

// ignore: must_be_immutable
class CustomOutLineButton extends StatelessWidget {
  CustomOutLineButton(
      {super.key,
      required this.onPressed,
      required this.child,
      this.borderColor,
      this.backGroundColor,
      this.radius,
      this.minimumSize,
      this.padding});

  void Function()? onPressed;
  Widget child;
  Color? borderColor;
  Color? backGroundColor;
  double? radius;
  Size? minimumSize = const Size(88, 36);
  EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
          minimumSize: minimumSize,
          shape: radius != null
              ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius!),
                )
              : null,
          side: borderColor != null ? BorderSide(color: borderColor!) : null,
          backgroundColor: backGroundColor),
      onPressed: onPressed,
      child: child,
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
      shape: isRounded == true ? const CircleBorder() : null,
      onChanged: onChanged,
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
          child: LocalCartRepo().checkIfServiceContainInCart(
                  allServiceList: state.serviceList.value ?? [],
                  serviceId: "${serviceModel?.serviceId}")
              ? CustomElevatedButton(
                  onPressed: () {
                    context.read<LocalCartBloc>().add(RemoveServiceFromCart(
                        serviceId: serviceModel?.serviceId ?? ""));
                  },
                  color: Colors.red,
                  radius: 5,
                  child: CustomText(TextUtils.remove,
                      color: Colors.white,
                      size: 14,
                      fontWeight: FontWeight.w700))
              : LocalCartRepo().checkIfPackageServiceContainInCart(
                      allServiceList: state.serviceList.value ?? [],
                      serviceModel: serviceModel)
                  ? Container()
                  : CustomElevatedButton(
                      onPressed: () {
                        context.read<LocalCartBloc>().add(AddServiceToCart(
                            serviceModel: CartServiceModel(
                                serviceId: serviceModel?.serviceId ?? "",
                                price: serviceModel?.offerFees ??
                                    serviceModel?.fees ??
                                    0.0,
                                listOfPackageService: LocalCartRepo()
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
                      color: HexColor.fromHex(ColorConst.green),
                      radius: 5,
                      child: CustomText(TextUtils.book_now,
                          color: Colors.white,
                          size: 14,
                          fontWeight: FontWeight.w700)),
        );
      },
    );
