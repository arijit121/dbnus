import 'package:dbnus/extension/spacing.dart';
import 'package:flutter/material.dart';
import '../../../const/color_const.dart';
import '../../../extension/hex_color.dart';
import '../../../widget/custom_image.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/custom_ui.dart';
import '../model/navigation_bar_model.dart';
import '../utils/landing_utils.dart';

class DrawerNavigationRail extends StatelessWidget {
  const DrawerNavigationRail(
      {super.key,
      required this.chooseIndex,
      this.withTitle,
      this.selectedIndex});
  final void Function(int) chooseIndex;
  final bool? withTitle;
  final int? selectedIndex;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: withTitle == true
          ? const EdgeInsets.symmetric(horizontal: 50, vertical: 20)
          : const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(topRight: Radius.circular(16.0)),
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
          children:
              List.generate(LandingUtils.listNavigationBar.length, (index) {
            NavigationBarModel navigationBarModel =
                LandingUtils.listNavigationBar.elementAt(index);
            return InkWell(
              onTap: () {
                chooseIndex(index);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (index == selectedIndex)
                    withTitle != true
                        ? CustomContainer(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            height: 44,
                            width: 44,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 6),
                            color: HexColor.fromHex(ColorConst.baseHexColor),
                            child: _DrawerNavigationRailWidget(
                              showTitle: withTitle == true,
                              color: Colors.white,
                              navigationBarModel: navigationBarModel,
                            ),
                          )
                        : CustomContainer(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            height: 44,
                            width: 172,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 22, vertical: 6),
                            color: HexColor.fromHex(ColorConst.baseHexColor),
                            child: _DrawerNavigationRailWidget(
                              showTitle: withTitle == true,
                              color: Colors.white,
                              navigationBarModel: navigationBarModel,
                            ),
                          )
                  else
                    _DrawerNavigationRailWidget(
                      showTitle: withTitle == true,
                      navigationBarModel: navigationBarModel,
                    ),
                  if (index != (LandingUtils.listNavigationBar.length - 1))
                    30.ph,
                ],
              ),
            );
          })),
    );
  }
}

class _DrawerNavigationRailWidget extends StatelessWidget {
  const _DrawerNavigationRailWidget(
      {this.showTitle, this.color, required this.navigationBarModel});
  final bool? showTitle;
  final Color? color;
  final NavigationBarModel navigationBarModel;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        navigationBarModel.icon.contains("https://") ||
                navigationBarModel.icon.contains("http://")
            ? navigationBarModel.icon.contains(".svg")
                ? CustomSvgNetworkImageView(
                    url: navigationBarModel.icon,
                    height: 32,
                    color: color ?? HexColor.fromHex(ColorConst.grey),
                  )
                : CustomNetWorkImageView(
                    url: navigationBarModel.icon,
                    height: 32,
                    color: color ?? HexColor.fromHex(ColorConst.grey),
                  )
            : navigationBarModel.icon.contains(".svg")
                ? CustomSvgAssetImageView(
                    path: navigationBarModel.icon,
                    height: 32,
                    color: color ?? HexColor.fromHex(ColorConst.grey),
                  )
                : CustomAssetImageView(
                    path: navigationBarModel.icon,
                    height: 32,
                    color: color ?? HexColor.fromHex(ColorConst.grey),
                  ),
        if (showTitle == true)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: CustomText(navigationBarModel.title,
                color: color ?? HexColor.fromHex(ColorConst.primaryDark)),
          )
      ],
    );
  }
}
