import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/ui/atoms/buttons/custom_button.dart';
import 'package:dbnus/shared/ui/atoms/images/custom_image.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
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
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: ValueListenableBuilder(
          valueListenable: _tag,
          builder: (_, __, ___) {
            return widget.expanded == true && !_tag.value
                ? Container(
                    decoration: BoxDecoration(
                      color: ColorConst.sidebarBg,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16.0, bottom: 8.0, left: 8, right: 8),
                          child: CustomIconButton(
                            iconSize: 24,
                            color: Colors.white70,
                            padding: EdgeInsets.all(8),
                            icon: Icon(FeatherIcons.sidebar),
                            onPressed: () {
                              _tag.value = true;
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          ColorConst.sidebarBg,
                          Color(0xFF252A3A),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(16.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8.0,
                          spreadRadius: 1.0,
                          offset: Offset(2, 0),
                        ),
                      ],
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Brand header
                          if (widget.expanded == true)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 36,
                                    width: 36,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                        colors: [
                                          ColorConst.sidebarSelected,
                                          ColorConst.violate,
                                        ],
                                      ),
                                    ),
                                    child: Center(
                                      child: CustomText(
                                        "D",
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                  10.pw,
                                  CustomText(
                                    "Dbnus",
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    size: 20,
                                  ),
                                  8.pw,
                                  CustomIconButton(
                                    iconSize: 22,
                                    color: Colors.white54,
                                    padding: EdgeInsets.all(4),
                                    icon: Icon(FeatherIcons.sidebar),
                                    onPressed: () {
                                      _tag.value = false;
                                    },
                                  ),
                                ],
                              ),
                            )
                          else if (widget.expanded != true)
                            SizedBox.shrink(),

                          // Divider
                          if (widget.withTitle == true)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Divider(
                                color: Colors.white12,
                                height: 1,
                              ),
                            ),

                          12.ph,

                          // Navigation items
                          ...List.generate(LandingUtils.listNavigation.length,
                              (index) {
                            NavigationOption navigationBarModel =
                                LandingUtils.listNavigation.elementAt(index);
                            bool isSelected = index == widget.selectedIndex;
                            return InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                widget.chooseIndex(index);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.easeInOut,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: isSelected
                                        ? ColorConst.sidebarSelected
                                            .withValues(alpha: 0.2)
                                        : Colors.transparent,
                                    border: isSelected
                                        ? Border.all(
                                            color: ColorConst.sidebarSelected
                                                .withValues(alpha: 0.4),
                                            width: 1,
                                          )
                                        : null,
                                  ),
                                  padding: widget.withTitle == true
                                      ? const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10)
                                      : const EdgeInsets.all(10),
                                  child: _DrawerNavigationRailWidget(
                                    showTitle: widget.withTitle == true,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.white60,
                                    navigationBarModel: navigationBarModel,
                                  ),
                                ),
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
                    height: 24,
                    color: color ?? Colors.white60,
                  )
                : CustomNetWorkImageView(
                    url: navigationBarModel.icon,
                    height: 24,
                    color: color ?? Colors.white60,
                  )
            : navigationBarModel.icon.contains(".svg")
                ? CustomSvgAssetImageView(
                    path: navigationBarModel.icon,
                    height: 24,
                    color: color ?? Colors.white60,
                  )
                : CustomAssetImageView(
                    path: navigationBarModel.icon,
                    height: 24,
                    color: color ?? Colors.white60,
                  ),
        if (showTitle == true)
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: CustomText(
                LandingUtils.getTranslatedTitle(
                    context, navigationBarModel.title),
                color: color ?? Colors.white60,
                fontWeight: FontWeight.w500),
          )
      ],
    );
  }
}
