import 'package:dbnus/extension/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../const/color_const.dart';
import '../../../extension/hex_color.dart';
import '../../../utils/screen_utils.dart';
import '../../../utils/text_utils.dart';
import '../../../widget/custom_button.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/custom_ui.dart';
import '../bloc/local_cart_bloc.dart';

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
                            color: Colors.black.withOpacity(0.25),
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
                            color: Colors.green,
                            size: 18,
                            fontWeight: FontWeight.w600),
                        const Spacer(),
                        CustomGOEButton(
                            radius: 10,
                            backGroundColor: HexColor.fromHex(ColorConst.green),
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
