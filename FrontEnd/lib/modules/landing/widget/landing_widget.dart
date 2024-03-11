import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:genu/const/color_const.dart';
import 'package:genu/extension/hex_color.dart';
import 'package:genu/extension/spacing.dart';
import 'package:genu/widget/custom_ui.dart';

import '../../../const/assects_const.dart';

class LandingWidget {
  Widget drawerNavigationRail() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius:
              const BorderRadius.horizontal(right: Radius.circular(6.0)),
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
          children: [
            Image.asset(
              AssetsConst.dashboardIcon,
              height: 34,
              color: HexColor.fromHex(ColorConst.grey),
            ),
            12.ph,
            SvgPicture.asset(
              height: 34,
              AssetsConst.leaderBoard,
              colorFilter: ColorFilter.mode(
                  HexColor.fromHex(ColorConst.grey), BlendMode.srcIn),
            ),
            12.ph,
            SvgPicture.asset(
              height: 34,
              AssetsConst.message,
              colorFilter: ColorFilter.mode(
                  HexColor.fromHex(ColorConst.grey), BlendMode.srcIn),
            ),
            12.ph,
            SvgPicture.asset(
              height: 34,
              AssetsConst.setting,
              colorFilter: ColorFilter.mode(
                  HexColor.fromHex(ColorConst.grey), BlendMode.srcIn),
            ),
            12.ph,
            SvgPicture.asset(
              height: 34,
              AssetsConst.shopping,
              colorFilter: ColorFilter.mode(
                  HexColor.fromHex(ColorConst.grey), BlendMode.srcIn),
            ),
            12.ph,
            SvgPicture.asset(
              height: 34,
              AssetsConst.signOut,
              colorFilter: ColorFilter.mode(
                  HexColor.fromHex(ColorConst.grey), BlendMode.srcIn),
            ),
          ],
        ),
      );
}
