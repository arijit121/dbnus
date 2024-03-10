import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genu/extension/spacing.dart';
import 'package:genu/utils/screen_utils.dart';
import 'package:genu/utils/text_utils.dart';
import 'package:genu/widget/custom_button.dart';
import 'package:genu/widget/custom_text.dart';
import 'package:genu/widget/custom_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../const/color_const.dart';
import '../../../extension/hex_color.dart';
import '../../../router/router_name.dart';
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
                      label: customText("${state.serviceList.value?.length}",
                          color: Colors.white, size: 11),
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: customCardDesign(
                        radius: 10,
                        minimumSize: const Size(40, 40),
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
                    height: 55 + ScreenUtils.paddingBottom,
                    padding: EdgeInsets.only(
                        left: ScreenUtils.paddingLeft + 5,
                        right: ScreenUtils.paddingRight + 5,
                        bottom: ScreenUtils.paddingBottom + 2,
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
                          label: customText(
                              "${state.serviceList.value?.length}",
                              color: Colors.white,
                              size: 11),
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: customCardDesign(
                            radius: 5,
                            minimumSize: const Size(40, 40),
                            color: Colors.orangeAccent.withOpacity(.2),
                            child: const Icon(
                              Icons.shopping_cart_outlined,
                              size: 23,
                              color: Colors.orangeAccent,
                            ),
                          ),
                        ),
                        22.pw,
                        customText(
                            "${TextUtils.rupee} ${state.totalPrice.value?.toInt() ?? ""}",
                            color: Colors.green,
                            size: 18,
                            fontWeight: FontWeight.w600),
                        const Spacer(),
                        customElevatedButton(
                            radius: 10,
                            color: HexColor.fromHex(ColorConst.green),
                            child: customText(TextUtils.go_to_cart,
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
