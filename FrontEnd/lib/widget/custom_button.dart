import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../extension/sizing.dart';
import '../widget/custom_text.dart';

import '../const/color_const.dart';
import '../data/model/service_model.dart';
import '../extension/hex_color.dart';
import '../service/redirect_engine.dart';
import '../storage/localCart/bloc/local_cart_bloc.dart';
import '../storage/localCart/model/cart_service_model.dart';
import '../storage/localCart/repo/local_cart_repo.dart';
import '../utils/text_utils.dart';

Widget customElevatedButton(
        {required Widget? child,
        required void Function()? onPressed,
        Color? color,
        Size? minimumSize = const Size(88, 36),
        double? radius,
        Gradient? gradient}) =>
    gradient != null
        ? Container(
            width: minimumSize?.width,
            height: minimumSize?.height,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.all(Radius.circular(radius ?? 2)),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                minimumSize: minimumSize,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(radius ?? 2)),
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(radius ?? 2)),
              ),
            ),
            onPressed: onPressed,
            child: child,
          );

Widget customTextButton(
        {required Widget child, required void Function()? onPressed}) =>
    TextButton(
        style: TextButton.styleFrom(
          foregroundColor:
              HexColor.fromHex(ColorConst.primaryDark).withOpacity(0.87),
          padding: const EdgeInsets.all(5.0),
        ),
        onPressed: onPressed,
        child: child);

Widget customIconButton(
        {required Widget icon, required void Function()? onPressed}) =>
    IconButton(
      icon: icon,
      onPressed: onPressed,
    );

Widget customOutLineButton({
  required void Function() onTap,
  Widget? child,
  required Color borderColor,
  Color? backGroundColor,
  double? radius,
  Size? minimumSize = const Size(88, 36),
}) =>
    OutlinedButton(
      style: OutlinedButton.styleFrom(
          minimumSize: minimumSize,
          shape: radius != null
              ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius),
                )
              : null,
          side: BorderSide(color: borderColor),
          backgroundColor: backGroundColor),
      onPressed: onTap,
      child: child,
    );

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
              ? customElevatedButton(
                  child: customText(TextUtils.remove,
                      color: Colors.white,
                      size: 14,
                      fontWeight: FontWeight.w700),
                  onPressed: () {
                    context.read<LocalCartBloc>().add(RemoveServiceFromCart(
                        serviceId: serviceModel?.serviceId ?? ""));
                  },
                  color: Colors.red,
                  radius: 5)
              : LocalCartRepo().checkIfPackageServiceContainInCart(
                      allServiceList: state.serviceList.value ?? [],
                      serviceModel: serviceModel)
                  ? Container()
                  : customElevatedButton(
                      child: customText(TextUtils.book_now,
                          color: Colors.white,
                          size: 14,
                          fontWeight: FontWeight.w700),
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
                      radius: 5),
        );
      },
    );

Widget genderButton(
        {required String title,
        required String assetName,
        required void Function() onTap,
        required bool isSelected}) =>
    InkWell(
      onTap: onTap,
      child: Column(
        children: [
          customText(title,
              color: HexColor.fromHex(ColorConst.primaryDark), size: 14.fs),
          Image.asset(
            assetName,
            height: 48.fs,
            width: 48.fs,
            color: isSelected
                ? HexColor.fromHex(ColorConst.baseHexColor)
                : Colors.grey,
          ),
        ],
      ),
    );
