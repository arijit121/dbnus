import 'package:jaspr/dom.dart' hide BorderRadius, Alignment;
import 'package:jaspr/jaspr.dart';
import '../../../navigation/route_names.dart';
import '../../constants/text_utils.dart';
import '../ui.dart';

class AppShell extends StatefulComponent {
  final Component child;
  final int selectedIndex;
  final void Function(int) onNavigate;

  const AppShell({
    required this.child,
    required this.selectedIndex,
    required this.onNavigate,
    super.key,
  });

  @override
  State<AppShell> createState() => _AppShellState();

  @css
  static List<StyleRule> get styles => _AppShellState.styles;
}

class _AppShellState extends State<AppShell> {
  bool _drawerOpen = false;

  static const navItems = [
    NavItem(
        title: TextUtils.dashboard,
        icon: '📊',
        route: RouteName.initialView),
    NavItem(
        title: TextUtils.leaderBoard,
        icon: '🏆',
        route: RouteName.leaderBoard),
    NavItem(title: TextUtils.order, icon: '🛒', route: RouteName.order),
    NavItem(title: TextUtils.game, icon: '🎮', route: RouteName.games),
    NavItem(title: TextUtils.bioData, icon: '🛡️', route: RouteName.bioData),
  ];

  void _toggleDrawer() {
    setState(() => _drawerOpen = !_drawerOpen);
  }

  @override
  Component build(BuildContext context) {
    return Container(
      className: 'app-shell',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          // Mobile overlay
          if (_drawerOpen)
            Container(
              className: 'drawer-overlay',
              events: {'click': (e) => _toggleDrawer()},
              child: const SizedBox(),
            ),
          // Sidebar - mobile drawer
          Container(
            className: 'sidebar-mobile ${_drawerOpen ? "open" : ""}',
            child: NavigationRail(
              selectedIndex: component.selectedIndex,
              items: navItems,
              expanded: true,
              showLabels: true,
              onSelect: (index) {
                setState(() => _drawerOpen = false);
                component.onNavigate(index);
              },
            ),
          ),
          // Sidebar - tablet (icons only)
          Container(
            className: 'sidebar-tablet',
            child: NavigationRail(
              selectedIndex: component.selectedIndex,
              items: navItems,
              expanded: false,
              showLabels: false,
              onSelect: component.onNavigate,
            ),
          ),
          // Sidebar - desktop (expanded)
          Container(
            className: 'sidebar-desktop',
            child: NavigationRail(
              selectedIndex: component.selectedIndex,
              items: navItems,
              expanded: true,
              showLabels: true,
              onSelect: component.onNavigate,
            ),
          ),
          // Content area
          Expanded(
            child: Container(
              className: 'shell-content',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  AppTopBar(onMenuTap: _toggleDrawer),
                  Expanded(
                    child: Container(
                      className: 'shell-body',
                      child: component.child,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static List<StyleRule> get styles => [
    css('.app-shell', [
      css('&').styles(
        display: .flex,
        raw: {'min-height': '100vh'},
      ),
      // Mobile sidebar (drawer)
      css('.sidebar-mobile').styles(
        raw: {
          'position': 'fixed',
          'top': '0',
          'left': '-260px',
          'z-index': '100',
          'height': '100vh',
          'transition': 'left 0.3s ease',
        },
      ),
      css('.sidebar-mobile.open').styles(
        raw: {'left': '0'},
      ),
      // Overlay
      css('.drawer-overlay').styles(
        raw: {
          'position': 'fixed',
          'inset': '0',
          'z-index': '90',
          'background': 'rgba(0,0,0,0.5)',
        },
      ),
      // Tablet sidebar (hidden by default, shown via media query)
      css('.sidebar-tablet').styles(display: .none),
      // Desktop sidebar (hidden by default, shown via media query)
      css('.sidebar-desktop').styles(display: .none),
      // Content
      css('.shell-content').styles(
        display: .flex,
        flexDirection: .column,
        raw: {'flex': '1', 'min-width': '0'},
      ),
      css('.shell-body').styles(
        padding: .all(16.px),
        raw: {'flex': '1', 'overflow-y': 'auto'},
      ),
    ]),
    // Tablet: show icon-only sidebar, hide mobile drawer
    css.media(MediaQuery.screen(minWidth: 769.px, maxWidth: 1024.px), [
      css('.sidebar-mobile').styles(display: .none),
      css('.sidebar-tablet').styles(display: .block),
      css('.shell-body').styles(
          padding: .symmetric(horizontal: 16.px, vertical: 16.px)),
    ]),
    // Desktop: show expanded sidebar
    css.media(MediaQuery.screen(minWidth: 1025.px), [
      css('.sidebar-mobile').styles(display: .none),
      css('.sidebar-desktop').styles(display: .block),
      css('.shell-body').styles(
          padding: .symmetric(horizontal: 24.px, vertical: 16.px)),
    ]),
  ];
}
