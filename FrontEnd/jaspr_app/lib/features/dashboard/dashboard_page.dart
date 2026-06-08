import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';
import '../../shared/constants/theme.dart';
import '../../shared/constants/text_utils.dart';
import '../../navigation/route_names.dart';

class DashboardPage extends StatelessComponent {
  const DashboardPage({super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'dashboard', [
      // Welcome header
      div(classes: 'welcome-section', [
        div(classes: 'welcome-text', [
          h2(classes: 'welcome-title', [text('${TextUtils.welcomeBack} 👋')]),
          p(classes: 'welcome-subtitle', [
            text('Here\'s what\'s happening with your projects today.'),
          ]),
        ]),
        div(classes: 'welcome-actions', [
          button(classes: 'action-btn primary', [text('+ New Project')]),
          button(classes: 'action-btn outlined', [text('Export')]),
        ]),
      ]),

      // Stats grid
      div(classes: 'stats-grid', [
        _statCard('💰', TextUtils.totalRevenue, '\$45,231', '+20.1% from last month', green),
        _statCard('📦', TextUtils.totalOrders, '2,350', '+15.3% from last month', lightBlue),
        _statCard('👥', TextUtils.activeUsers, '12,234', '+4.5% from last month', violate),
        _statCard('📈', TextUtils.growth, '+573', '+201 since last hour', deepGreen),
      ]),

      // Quick actions
      div(classes: 'section-card', [
        div(classes: 'section-header', [
          h3([text('Quick Actions')]),
          button(classes: 'view-all-btn', [text(TextUtils.viewAll)]),
        ]),
        div(classes: 'quick-grid', [
          _quickAction('📊', 'Analytics', 'View detailed reports'),
          _quickAction('🛒', 'Orders', 'Manage your orders', route: RouteName.order),
          _quickAction('🎮', 'Games', 'Play mini games', route: RouteName.games),
          _quickAction('🏆', 'Leaderboard', 'Check rankings', route: RouteName.leaderBoard),
          _quickAction('🛡️', 'Bio Data', 'Manage your profile', route: RouteName.bioData),
          _quickAction('🗺️', 'Maps', 'Explore locations', route: RouteName.openStreetMap),
        ]),
      ]),

      // Recent activity
      div(classes: 'section-card', [
        div(classes: 'section-header', [
          h3([text('Recent Activity')]),
        ]),
        div(classes: 'activity-list', [
          _activityItem('🟢', 'New order received', 'Order #1234 from John Doe', '2 min ago'),
          _activityItem('🔵', 'Payment completed', '\$350.00 payment processed', '15 min ago'),
          _activityItem('🟡', 'New user registered', 'jane.doe@email.com joined', '1 hour ago'),
          _activityItem('🟣', 'Report generated', 'Monthly analytics report ready', '3 hours ago'),
          _activityItem('🔴', 'Server alert', 'High CPU usage detected', '5 hours ago'),
        ]),
      ]),
    ]);
  }

  Component _statCard(String icon, String title, String value, String change, Color accent) {
    return div(classes: 'stat-card', [
      div(classes: 'stat-header', [
        span(
          classes: 'stat-icon',
          styles: Styles(raw: {
            'background':
                'linear-gradient(135deg, ${accent.value}20, ${accent.value}10)',
          }),
          [text(icon)],
        ),
        p(classes: 'stat-title', [text(title)]),
      ]),
      h3(classes: 'stat-value', [text(value)]),
      p(classes: 'stat-change', styles: Styles(raw: {'color': accent.value}), [
        text(change),
      ]),
    ]);
  }

  Component _quickAction(String icon, String title, String desc, {String? route}) {
    final actionCard = div(classes: 'quick-action', [
      div(classes: 'quick-icon', [text(icon)]),
      div([
        p(classes: 'quick-title', [text(title)]),
        p(classes: 'quick-desc', [text(desc)]),
      ]),
    ]);

    if (route != null) {
      return Link(to: route, child: actionCard);
    }
    return actionCard;
  }

  Component _activityItem(String dot, String title, String desc, String time) {
    return div(classes: 'activity-item', [
      span(classes: 'activity-dot', [text(dot)]),
      div(classes: 'activity-info', [
        p(classes: 'activity-title', [text(title)]),
        p(classes: 'activity-desc', [text(desc)]),
      ]),
      span(classes: 'activity-time', [text(time)]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
        css('.dashboard', [
          css('&').styles(
            display: .flex,
            flexDirection: .column,
            gap: Gap.all(24.px),
            raw: {'animation': 'fadeIn 0.4s ease'},
          ),
        ]),
        // Welcome section
        css('.welcome-section', [
          css('&').styles(
            display: .flex,
            justifyContent: .spaceBetween,
            alignItems: .center,
            flexWrap: .wrap,
            gap: Gap.all(16.px),
          ),
          css('.welcome-title').styles(
            fontSize: 1.75.rem,
            fontWeight: .w700,
            color: primaryDark,
          ),
          css('.welcome-subtitle').styles(
            fontSize: 14.px,
            color: secondaryDark,
            margin: .zero,
            raw: {'margin-top': '4px'},
          ),
          css('.welcome-actions').styles(
            display: .flex,
            gap: Gap.all(12.px),
          ),
          css('.action-btn').styles(
            padding: .symmetric(horizontal: 20.px, vertical: 10.px),
            radius: .all(.circular(10.px)),
            fontSize: 14.px,
            fontWeight: .w600,
            cursor: .pointer,
            border: .none,
            raw: {'transition': 'all 0.2s ease'},
          ),
          css('.action-btn.primary').styles(
            backgroundColor: baseHexColor,
            color: Colors.white,
          ),
          css('.action-btn.primary:hover').styles(
            raw: {
              'transform': 'translateY(-1px)',
              'box-shadow': '0 4px 12px rgba(108,99,255,0.4)',
            },
          ),
          css('.action-btn.outlined').styles(
            backgroundColor: Colors.white,
            color: primaryDark,
            raw: {'border': '1.5px solid #E2E8F0'},
          ),
          css('.action-btn.outlined:hover').styles(
            raw: {'border-color': '#94A3B8'},
          ),
        ]),
        // Stats grid
        css('.stats-grid').styles(
          display: .grid,
          gap: Gap.all(20.px),
          raw: {'grid-template-columns': 'repeat(auto-fit, minmax(220px, 1fr))'},
        ),
        css('.stat-card', [
          css('&').styles(
            backgroundColor: Colors.white,
            radius: .all(.circular(16.px)),
            padding: .all(20.px),
            raw: {
              'box-shadow': '0 1px 3px rgba(0,0,0,0.04), 0 1px 2px rgba(0,0,0,0.06)',
              'transition': 'transform 0.2s ease, box-shadow 0.2s ease',
            },
          ),
          css('&:hover').styles(
            raw: {
              'transform': 'translateY(-2px)',
              'box-shadow': '0 4px 12px rgba(0,0,0,0.08)',
            },
          ),
          css('.stat-header').styles(
            display: .flex,
            alignItems: .center,
            gap: Gap.all(10.px),
            raw: {'margin-bottom': '12px'},
          ),
          css('.stat-icon').styles(
            display: .flex,
            alignItems: .center,
            justifyContent: .center,
            width: 40.px,
            height: 40.px,
            radius: .all(.circular(10.px)),
            fontSize: 18.px,
          ),
          css('.stat-title').styles(
            fontSize: 13.px,
            fontWeight: .w500,
            color: secondaryDark,
            margin: .zero,
          ),
          css('.stat-value').styles(
            fontSize: 28.px,
            fontWeight: .w700,
            color: primaryDark,
            margin: .zero,
            raw: {'margin-bottom': '4px'},
          ),
          css('.stat-change').styles(
            fontSize: 12.px,
            margin: .zero,
            fontWeight: .w500,
          ),
        ]),
        // Section cards
        css('.section-card', [
          css('&').styles(
            backgroundColor: Colors.white,
            radius: .all(.circular(16.px)),
            padding: .all(24.px),
            raw: {
              'box-shadow': '0 1px 3px rgba(0,0,0,0.04)',
            },
          ),
          css('.section-header').styles(
            display: .flex,
            justifyContent: .spaceBetween,
            alignItems: .center,
            raw: {'margin-bottom': '20px'},
          ),
          css('.view-all-btn').styles(
            fontSize: 13.px,
            fontWeight: .w600,
            color: baseHexColor,
            cursor: .pointer,
            border: .none,
            raw: {'background-color': 'transparent'},
          ),
        ]),
        // Quick actions grid
        css('.quick-grid').styles(
          display: .grid,
          gap: Gap.all(12.px),
          raw: {'grid-template-columns': 'repeat(auto-fit, minmax(200px, 1fr))'},
        ),
        css('.quick-action', [
          css('&').styles(
            display: .flex,
            alignItems: .center,
            gap: Gap.all(14.px),
            padding: .all(16.px),
            radius: .all(.circular(12.px)),
            backgroundColor: scaffoldBg,
            cursor: .pointer,
            raw: {'transition': 'all 0.2s ease'},
          ),
          css('&:hover').styles(
            raw: {
              'transform': 'translateX(4px)',
              'background': '#EEF2FF',
            },
          ),
          css('.quick-icon').styles(
            fontSize: 24.px,
            width: 44.px,
            height: 44.px,
            display: .flex,
            alignItems: .center,
            justifyContent: .center,
            radius: .all(.circular(10.px)),
            backgroundColor: Colors.white,
            raw: {'flex-shrink': '0'},
          ),
          css('.quick-title').styles(
            fontSize: 14.px,
            fontWeight: .w600,
            margin: .zero,
            color: primaryDark,
          ),
          css('.quick-desc').styles(
            fontSize: 12.px,
            color: grey,
            margin: .zero,
            raw: {'margin-top': '2px'},
          ),
        ]),
        // Activity list
        css('.activity-list').styles(
          display: .flex,
          flexDirection: .column,
          gap: Gap.all(4.px),
        ),
        css('.activity-item', [
          css('&').styles(
            display: .flex,
            alignItems: .center,
            gap: Gap.all(12.px),
            padding: .symmetric(horizontal: 12.px, vertical: 14.px),
            radius: .all(.circular(10.px)),
            raw: {'transition': 'background 0.15s ease'},
          ),
          css('&:hover').styles(backgroundColor: scaffoldBg),
          css('.activity-dot').styles(fontSize: 16.px, raw: {'flex-shrink': '0'}),
          css('.activity-info').styles(raw: {'flex': '1', 'min-width': '0'}),
          css('.activity-title').styles(
            fontSize: 14.px,
            fontWeight: .w500,
            color: primaryDark,
            margin: .zero,
          ),
          css('.activity-desc').styles(
            fontSize: 12.px,
            color: grey,
            margin: .zero,
            raw: {'margin-top': '2px'},
          ),
          css('.activity-time').styles(
            fontSize: 12.px,
            color: grey,
            raw: {'flex-shrink': '0', 'white-space': 'nowrap'},
          ),
        ]),
      ];
}
