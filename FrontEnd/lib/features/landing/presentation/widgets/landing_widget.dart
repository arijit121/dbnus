import 'package:dbnus/core/extensions/spacing.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

import 'package:dbnus/core/constants/color_const.dart';
import 'package:dbnus/shared/ui/atoms/buttons/custom_button.dart';
import 'package:dbnus/shared/ui/atoms/images/custom_image.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:dbnus/shared/ui/utils/custom_ui.dart';
import 'package:dbnus/features/landing/domain/entities/navigation_option.dart';
import 'package:dbnus/features/landing/presentation/utils/landing_utils.dart';

class DrawerNavigationRail extends StatefulWidget {
  const DrawerNavigationRail(
      {super.key,
      required this.chooseIndex,
      this.withTitle,
      this.expanded,
      this.selectedIndex});

  final void Function(int) chooseIndex;
  final bool? withTitle, expanded;
  final int? selectedIndex;

  @override
  State<DrawerNavigationRail> createState() => _DrawerNavigationRailState();
}

class _DrawerNavigationRailState extends State<DrawerNavigationRail> {
  final ValueNotifier<bool> _tag = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: Duration(milliseconds: 120),
      child: ValueListenableBuilder(
          valueListenable: _tag,
          builder: (_, __, ___) {
            return widget.expanded == true && !_tag.value
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 8.0, left: 8),
                        child: CustomIconButton(
                          iconSize: 24,
                          color: ColorConst.primaryDark,
                          padding: EdgeInsets.all(8),
                          icon: Icon(FeatherIcons.sidebar),
                          onPressed: () {
                            _tag.value = true;
                          },
                        ),
                      ),
                    ],
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(16.0)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: ColorConst.grey,
                          blurRadius: 4.0,
                          spreadRadius: 1.0,
                        ),
                      ],
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.expanded == true)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: CustomIconButton(
                                iconSize: 24,
                                color: ColorConst.primaryDark,
                                padding: EdgeInsets.zero,
                                icon: Icon(FeatherIcons.sidebar),
                                onPressed: () {
                                  _tag.value = false;
                                },
                              ),
                            ),
                          ...List.generate(LandingUtils.listNavigation.length,
                              (index) {
                            NavigationOption navigationBarModel =
                                LandingUtils.listNavigation.elementAt(index);
                            return InkWell(
                              onTap: () {
                                widget.chooseIndex(index);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (index == widget.selectedIndex)
                                    widget.withTitle != true
                                        ? CustomContainer(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(12)),
                                            height: 44,
                                            width: 44,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 6),
                                            color: ColorConst.baseHexColor,
                                            child: _DrawerNavigationRailWidget(
                                              showTitle:
                                                  widget.withTitle == true,
                                              color: Colors.white,
                                              navigationBarModel:
                                                  navigationBarModel,
                                            ),
                                          )
                                        : CustomContainer(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(12)),
                                            height: 44,
                                            width: 172,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 22, vertical: 6),
                                            color: ColorConst.baseHexColor,
                                            child: _DrawerNavigationRailWidget(
                                              showTitle:
                                                  widget.withTitle == true,
                                              color: Colors.white,
                                              navigationBarModel:
                                                  navigationBarModel,
                                            ),
                                          )
                                  else
                                    _DrawerNavigationRailWidget(
                                      showTitle: widget.withTitle == true,
                                      navigationBarModel: navigationBarModel,
                                    ),
                                  if (index !=
                                      (LandingUtils.listNavigation.length - 1))
                                    30.ph,
                                ],
                              ),
                            );
                          }),
                        ]),
                  );
          }),
    );
  }
}

class _DrawerNavigationRailWidget extends StatelessWidget {
  const _DrawerNavigationRailWidget(
      {this.showTitle, this.color, required this.navigationBarModel});

  final bool? showTitle;
  final Color? color;
  final NavigationOption navigationBarModel;

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
                    color: color ?? ColorConst.redGrey,
                  )
                : CustomNetWorkImageView(
                    url: navigationBarModel.icon,
                    height: 32,
                    color: color ?? ColorConst.redGrey,
                  )
            : navigationBarModel.icon.contains(".svg")
                ? CustomSvgAssetImageView(
                    path: navigationBarModel.icon,
                    height: 32,
                    color: color ?? ColorConst.redGrey,
                  )
                : CustomAssetImageView(
                    path: navigationBarModel.icon,
                    height: 32,
                    color: color ?? ColorConst.redGrey,
                  ),
        if (showTitle == true)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: CustomText(navigationBarModel.title,
                color: color ?? ColorConst.primaryDark),
          )
      ],
    );
  }
}
