import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/utils/screen_utils.dart';
import 'package:dbnus/shared/utils/text_utils.dart';
import 'package:dbnus/shared/ui/atoms/buttons/custom_button.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:dbnus/shared/ui/utils/custom_ui.dart';
import 'package:dbnus/core/storage/localCart/bloc/local_cart_bloc.dart';

//ignore: must_be_immutable
class LocalCartButtonWidget extends StatelessWidget {
  LocalCartButtonWidget({super.key, this.onlyIcon});

  bool? onlyIcon;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalCartBloc, LocalCartState>(
      builder: (context, state) {
        return state.serviceList.value?.isNotEmpty == true
            ? onlyIcon == true
                ? InkWell(
                    child: Badge(
                      label: CustomText("${state.serviceList.value?.length}",
                          color: Colors.white, size: 11),
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: CustomContainer(
                        // radius: 10,
                        // minimumSize: const Size(40, 40),
                        color: Colors.orangeAccent.withOpacity(.2),
                        child: const Icon(
                          Icons.shopping_cart_outlined,
                          size: 23,
                          color: Colors.orangeAccent,
                        ),
                      ),
                    ),
                    onTap: () {
                      // kIsWeb
                      //     ? context.goNamed(RouteName.cart)
                      //     : context.pushNamed(RouteName.cart);
                    },
                  )
                : Container(
                    height: 55 + (ScreenUtils.paddingBottom()),
                    padding: EdgeInsets.only(
                        left: (ScreenUtils.paddingLeft()) + 5,
                        right: (ScreenUtils.paddingRight()) + 5,
                        bottom: (ScreenUtils.paddingBottom()) + 2,
                        top: 5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: ColorConst.primaryDark.withOpacity(0.25),
                            blurRadius: 5.0,
                            spreadRadius: 3,
                          )
                        ],
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(10))),
                    child: Row(
                      children: [
                        Badge(
                          label: CustomText(
                              "${state.serviceList.value?.length}",
                              color: Colors.white,
                              size: 11),
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: CustomContainer(
                            // radius: 5,
                            // minimumSize: const Size(40, 40),
                            color: Colors.orangeAccent.withOpacity(.2),
                            child: const Icon(
                              Icons.shopping_cart_outlined,
                              size: 23,
                              color: Colors.orangeAccent,
                            ),
                          ),
                        ),
                        22.pw,
                        CustomText(
                            "${TextUtils.rupee} ${state.totalPrice.value?.toInt() ?? ""}",
                            color: ColorConst.green,
                            size: 18,
                            fontWeight: FontWeight.w600),
                        const Spacer(),
                        CustomGOEButton(
                            radius: 10,
                            backGroundColor: ColorConst.green,
                            child: CustomText(TextUtils.go_to_cart,
                                color: Colors.white, size: 14),
                            onPressed: () {
                              // kIsWeb
                              //     ? context.goNamed(RouteName.cart)
                              //     : context.pushNamed(RouteName.cart);
                            })
                      ],
                    ),
                  )
            : Container(
                height: 0,
              );
      },
    );
  }
}
