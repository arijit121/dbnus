import 'package:jaspr/dom.dart' hide BorderRadius, Alignment;
import 'package:jaspr/jaspr.dart';
import '../../constants/theme.dart';
import '../ui.dart';

class NavItem {
  final String title;
  final String icon;
  final String route;
  const NavItem({required this.title, required this.icon, required this.route});
}

class NavigationRail extends StatelessComponent {
  final int selectedIndex;
  final bool expanded;
  final bool showLabels;
  final void Function(int index)? onSelect;
  final List<NavItem> items;

  const NavigationRail({
    required this.selectedIndex,
    required this.items,
    this.expanded = false,
    this.showLabels = false,
    this.onSelect,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return Container(
      className: 'nav-rail ${expanded ? "nav-rail-expanded" : ""}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo header
          Row(
            className: 'nav-rail-logo',
            crossAxisAlignment: CrossAxisAlignment.center,
            gap: 12,
            children: [
              Container(
                className: 'nav-logo-icon',
                width: 36,
                height: 36,
                alignment: Alignment.center,
                child: const CustomText('D', fontWeight: FontWeight.w700, color: Colors.white),
              ),
              if (expanded || showLabels)
                const CustomText('Dbnus', className: 'nav-logo-text', fontWeight: FontWeight.w700, color: Colors.white, variant: TextVariant.h3),
            ],
          ),
          // Divider
          const Container(className: 'nav-rail-divider'),
          // Nav items
          Container(
            className: 'nav-rail-items',
            child: Column(
              gap: 4,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < items.length; i++)
                  _buildNavItem(context, i, items[i]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Component _buildNavItem(BuildContext context, int index, NavItem item) {
    final isActive = index == selectedIndex;
    return Container(
      className: 'nav-item ${isActive ? "nav-item-active" : ""}',
      events: {'click': (e) => onSelect?.call(index)},
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        gap: 12,
        children: [
          CustomText(item.icon, className: 'nav-item-icon'),
          if (expanded || showLabels)
            CustomText(item.title, className: 'nav-item-label', fontWeight: FontWeight.w500),
        ],
      ),
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.nav-rail', [
      css('&').styles(
        display: .flex,
        flexDirection: .column,
        backgroundColor: sidebarBg,
        padding: .symmetric(vertical: 20.px, horizontal: 12.px),
        width: 72.px,
        raw: {'min-height': '100vh', 'transition': 'width 0.3s ease'},
      ),
      css('&.nav-rail-expanded').styles(width: 240.px),
      css('.nav-rail-logo').styles(
        display: .flex,
        alignItems: .center,
        gap: Gap.all(12.px),
        padding: .symmetric(horizontal: 8.px, vertical: 8.px),
        raw: {'margin-bottom': '8px'},
      ),
      css('.nav-logo-icon').styles(
        width: 36.px,
        height: 36.px,
        radius: .all(.circular(10.px)),
        display: .flex,
        alignItems: .center,
        justifyContent: .center,
        color: Colors.white,
        fontWeight: .w700,
        fontSize: 16.px,
        raw: {
          'background': 'linear-gradient(135deg, #6366F1, #8B5CF6)',
          'flex-shrink': '0',
        },
      ),
      css('.nav-logo-text').styles(
        color: Colors.white,
        fontWeight: .w700,
        fontSize: 20.px,
        raw: {'white-space': 'nowrap'},
      ),
      css('.nav-rail-divider').styles(
        height: 1.px,
        backgroundColor: const Color('#FFFFFF15'),
        margin: .symmetric(vertical: 12.px, horizontal: 4.px),
      ),
      css('.nav-rail-items').styles(
        display: .flex,
        flexDirection: .column,
        gap: Gap.all(4.px),
        raw: {'flex': '1'},
      ),
      css('.nav-item', [
        css('&').styles(
          display: .flex,
          alignItems: .center,
          gap: Gap.all(12.px),
          padding: .symmetric(horizontal: 12.px, vertical: 12.px),
          radius: .all(.circular(10.px)),
          cursor: .pointer,
          color: const Color('#94A3B8'),
          raw: {'transition': 'all 0.2s ease'},
        ),
        css('&:hover').styles(
          backgroundColor: const Color('#FFFFFF10'),
          color: Colors.white,
        ),
        css('&.nav-item-active').styles(
          backgroundColor: sidebarSelected,
          color: Colors.white,
          raw: {'box-shadow': '0 4px 12px rgba(99, 102, 241, 0.4)'},
        ),
        css('.nav-item-icon').styles(
          fontSize: 20.px,
          width: 24.px,
          raw: {'text-align': 'center', 'flex-shrink': '0'},
        ),
        css('.nav-item-label').styles(
          fontSize: 14.px,
          fontWeight: .w500,
          raw: {'white-space': 'nowrap'},
        ),
      ]),
    ]),
  ];
}
