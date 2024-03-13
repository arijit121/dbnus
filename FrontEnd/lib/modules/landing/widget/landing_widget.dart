import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:genu/const/color_const.dart';
import 'package:genu/extension/hex_color.dart';
import 'package:genu/extension/spacing.dart';
import 'package:genu/utils/text_utils.dart';
import 'package:genu/widget/custom_text.dart';

import '../../../const/assects_const.dart';

class LandingWidget {
  Widget drawerNavigationRail(
          {required void Function(int value) chooseIndex, bool? withTitle}) =>
      Container(
        padding: withTitle == true
            ? const EdgeInsets.symmetric(horizontal: 50, vertical: 20)
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          borderRadius:
              const BorderRadius.only(topRight: Radius.circular(16.0)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: HexColor.fromHex(ColorConst.grey4),
              blurRadius: 4.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
                drawerNavigationRailList().length,
                (index) => InkWell(
                      onTap: () {
                        chooseIndex(index);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          drawerNavigationRailList(showTitle: withTitle == true)
                              .elementAt(index),
                          if (index != (drawerNavigationRailList().length - 1))
                            30.ph,
                        ],
                      ),
                    ))),
      );

  List<Widget> drawerNavigationRailList({bool? showTitle}) => [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AssetsConst.dashboardIcon,
              height: 32,
              color: HexColor.fromHex(ColorConst.grey),
            ),
            if (showTitle == true)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: customText(TextUtils.dashboard),
              )
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              height: 32,
              AssetsConst.leaderBoard,
              colorFilter: ColorFilter.mode(
                  HexColor.fromHex(ColorConst.grey), BlendMode.srcIn),
            ),
            if (showTitle == true)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: customText(TextUtils.leaderBoard),
              )
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              height: 32,
              AssetsConst.shoppingCart,
              colorFilter: ColorFilter.mode(
                  HexColor.fromHex(ColorConst.grey), BlendMode.srcIn),
            ),
            if (showTitle == true)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: customText(TextUtils.order),
              )
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              height: 32,
              AssetsConst.shopping,
              colorFilter: ColorFilter.mode(
                  HexColor.fromHex(ColorConst.grey), BlendMode.srcIn),
            ),
            if (showTitle == true)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: customText(TextUtils.products),
              )
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              height: 32,
              AssetsConst.message,
              colorFilter: ColorFilter.mode(
                  HexColor.fromHex(ColorConst.grey), BlendMode.srcIn),
            ),
            if (showTitle == true)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: customText(TextUtils.message),
              )
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              height: 32,
              AssetsConst.setting,
              colorFilter: ColorFilter.mode(
                  HexColor.fromHex(ColorConst.grey), BlendMode.srcIn),
            ),
            if (showTitle == true)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: customText(TextUtils.settings),
              )
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              height: 32,
              AssetsConst.signOut,
              colorFilter: ColorFilter.mode(
                  HexColor.fromHex(ColorConst.grey), BlendMode.srcIn),
            ),
            if (showTitle == true)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: customText(TextUtils.sign_out),
              )
          ],
        ),
      ];
}
