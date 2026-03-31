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
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: ValueListenableBuilder(
          valueListenable: _tag,
          builder: (_, __, ___) {
            // Collapsed mini rail
            if (widget.expanded == true && !_tag.value) {
              return _buildCollapsedRail();
            }
            // Expanded sidebar
            return _buildExpandedRail();
          }),
    );
  }

  Widget _buildCollapsedRail() {
    return Container(
      width: 64,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1A1D2E),
            Color(0xFF15172A),
          ],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Collapsed brand icon
          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                colors: [
                  ColorConst.sidebarSelected,
                  ColorConst.violate,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: ColorConst.violate.withValues(alpha: 0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Center(
              child: CustomText(
                "D",
                color: Colors.white,
                fontWeight: FontWeight.bold,
                size: 16,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Expand button
          CustomIconButton(
            iconSize: 20,
            color: Colors.white54,
            padding: const EdgeInsets.all(8),
            icon: const Icon(FeatherIcons.chevronsRight),
            onPressed: () {
              _tag.value = true;
            },
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Divider(
              color: Colors.white.withValues(alpha: 0.08),
              height: 1,
            ),
          ),
          const SizedBox(height: 12),

          // Collapsed nav items (icon only)
          ...List.generate(LandingUtils.listNavigation.length, (index) {
            NavigationOption nav =
                LandingUtils.listNavigation.elementAt(index);
            bool isSelected = index == widget.selectedIndex;
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              child: _CollapsedNavItem(
                nav: nav,
                isSelected: isSelected,
                onTap: () => widget.chooseIndex(index),
              ),
            );
          }),

          const Spacer(),

          // Bottom avatar
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _UserAvatarMini(),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedRail() {
    return Container(
      width: widget.withTitle == true ? 220 : null,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A1D2E),
            Color(0xFF15172A),
            Color(0xFF1A1D2E),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
        borderRadius:
            const BorderRadius.only(topRight: Radius.circular(20.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 16.0,
            spreadRadius: 1.0,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand header
          if (widget.expanded == true)
            _BrandHeader(
              onCollapse: () {
                _tag.value = false;
              },
            )
          else if (widget.expanded != true)
            const SizedBox.shrink(),

          // Divider
          if (widget.withTitle == true)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Divider(
                color: Colors.white.withValues(alpha: 0.07),
                height: 1,
              ),
            ),

          // Section label
          if (widget.withTitle == true)
            Padding(
              padding:
                  const EdgeInsets.only(left: 12, top: 8, bottom: 12),
              child: CustomText(
                "NAVIGATION",
                color: Colors.white.withValues(alpha: 0.3),
                size: 10,
                fontWeight: FontWeight.w700,
              ),
            )
          else
            12.ph,

          // Navigation items
          ...List.generate(LandingUtils.listNavigation.length, (index) {
            NavigationOption navigationBarModel =
                LandingUtils.listNavigation.elementAt(index);
            bool isSelected = index == widget.selectedIndex;
            return Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: _NavItem(
                nav: navigationBarModel,
                isSelected: isSelected,
                showTitle: widget.withTitle == true,
                onTap: () => widget.chooseIndex(index),
              ),
            );
          }),

          const Spacer(),

          // Bottom user section
          if (widget.withTitle == true) ...[
            Divider(
              color: Colors.white.withValues(alpha: 0.07),
              height: 1,
            ),
            12.ph,
            _UserSection(),
          ],
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
// Brand Header
// ══════════════════════════════════════════════════════════
class _BrandHeader extends StatelessWidget {
  const _BrandHeader({required this.onCollapse});
  final VoidCallback onCollapse;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          // Logo
          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                colors: [
                  ColorConst.sidebarSelected,
                  ColorConst.violate,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: ColorConst.violate.withValues(alpha: 0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Center(
              child: CustomText(
                "D",
                color: Colors.white,
                fontWeight: FontWeight.bold,
                size: 16,
              ),
            ),
          ),
          10.pw,
          const Expanded(
            child: CustomText(
              "Dbnus",
              color: Colors.white,
              fontWeight: FontWeight.w700,
              size: 20,
            ),
          ),
          // Collapse button
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconButton(
              iconSize: 18,
              color: Colors.white38,
              padding: const EdgeInsets.all(6),
              icon: const Icon(FeatherIcons.chevronsLeft),
              onPressed: onCollapse,
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
// Expanded Nav Item
// ══════════════════════════════════════════════════════════
class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.nav,
    required this.isSelected,
    required this.showTitle,
    required this.onTap,
  });

  final NavigationOption nav;
  final bool isSelected;
  final bool showTitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        splashColor: ColorConst.sidebarSelected.withValues(alpha: 0.15),
        highlightColor: ColorConst.sidebarSelected.withValues(alpha: 0.08),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isSelected
                ? ColorConst.sidebarSelected.withValues(alpha: 0.15)
                : Colors.transparent,
            border: isSelected
                ? Border.all(
                    color:
                        ColorConst.sidebarSelected.withValues(alpha: 0.3),
                    width: 1,
                  )
                : Border.all(color: Colors.transparent, width: 1),
          ),
          padding: showTitle
              ? const EdgeInsets.symmetric(horizontal: 14, vertical: 10)
              : const EdgeInsets.all(10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Active indicator dot
              if (isSelected && showTitle)
                Container(
                  width: 3,
                  height: 20,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        ColorConst.sidebarSelected,
                        ColorConst.violate,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              _NavigationIcon(
                icon: nav.icon,
                color: isSelected ? Colors.white : Colors.white54,
              ),
              if (showTitle)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: CustomText(
                      LandingUtils.getTranslatedTitle(context, nav.title),
                      color: isSelected ? Colors.white : Colors.white54,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      size: 14,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
// Collapsed Nav Item (icon only)
// ══════════════════════════════════════════════════════════
class _CollapsedNavItem extends StatelessWidget {
  const _CollapsedNavItem({
    required this.nav,
    required this.isSelected,
    required this.onTap,
  });

  final NavigationOption nav;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: LandingUtils.getTranslatedTitle(context, nav.title),
      preferBelow: false,
      verticalOffset: 0,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          splashColor: ColorConst.sidebarSelected.withValues(alpha: 0.15),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isSelected
                  ? ColorConst.sidebarSelected.withValues(alpha: 0.15)
                  : Colors.transparent,
            ),
            child: Center(
              child: _NavigationIcon(
                icon: nav.icon,
                color: isSelected ? Colors.white : Colors.white54,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
// Navigation Icon Handler
// ══════════════════════════════════════════════════════════
class _NavigationIcon extends StatelessWidget {
  const _NavigationIcon({
    required this.icon,
    this.color,
  });

  final String icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? Colors.white60;
    if (icon.contains("https://") || icon.contains("http://")) {
      return icon.contains(".svg")
          ? CustomSvgNetworkImageView(url: icon, height: 22, color: c)
          : CustomNetWorkImageView(url: icon, height: 22, color: c);
    }
    return icon.contains(".svg")
        ? CustomSvgAssetImageView(path: icon, height: 22, color: c)
        : CustomAssetImageView(path: icon, height: 22, color: c);
  }
}

// ══════════════════════════════════════════════════════════
// User Section
// ══════════════════════════════════════════════════════════
class _UserSection extends StatelessWidget {
  const _UserSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF4E69F4)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Icon(FeatherIcons.user, color: Colors.white, size: 16),
            ),
          ),
          10.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  "User",
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  size: 13,
                ),
                CustomText(
                  "Online",
                  color: Colors.white.withValues(alpha: 0.4),
                  size: 11,
                ),
              ],
            ),
          ),
          Icon(
            FeatherIcons.moreHorizontal,
            color: Colors.white.withValues(alpha: 0.3),
            size: 16,
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
// Mini User Avatar (for collapsed rail)
// ══════════════════════════════════════════════════════════
class _UserAvatarMini extends StatelessWidget {
  const _UserAvatarMini();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF4E69F4)],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Icon(FeatherIcons.user, color: Colors.white, size: 16),
      ),
    );
  }
}
