import 'dart:async';
import 'package:jaspr/dom.dart' hide BorderRadius, Alignment;
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../../../../flavors.dart';
import '../../../../shared/constants/theme.dart';
import '../../../../shared/constants/text_utils.dart';
import '../../../../navigation/route_names.dart';
import '../../../../core/models/dynamic_data.dart';
import '../../data/datasources/dashboard_remote_data_source.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/usecases/get_dashboard_data.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../../../../shared/ui/ui.dart';

class DashboardPage extends StatefulComponent {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final DashboardBloc _bloc;
  late final StreamSubscription<DashboardState> _subscription;
  DashboardState _state = DashboardState.initial();

  @override
  void initState() {
    super.initState();
    final remoteDataSource = DashboardRemoteDataSourceImpl();
    final repository = DashboardRepositoryImpl(remoteDataSource: remoteDataSource);
    final usecase = GetDashboardData(repository);

    _bloc = DashboardBloc(getDashboardData: usecase)..add(const FetchDashboardData());
    _state = _bloc.state;
    _subscription = _bloc.stream.listen((state) {
      setState(() {
        _state = state;
      });
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    _bloc.close();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    final currentState = _state;
    final status = currentState.dashboardData.status;

    return Column(
      className: 'dashboard',
      gap: 24,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Welcome header (Always visible)
        Row(
          className: 'welcome-section',
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText('${TextUtils.welcomeBack} 👋', variant: TextVariant.h2, className: 'welcome-title'),
                const CustomText(
                  'Here\'s what\'s happening with your projects today.',
                  className: 'welcome-subtitle',
                  variant: TextVariant.bodySmall,
                ),
              ],
            ),
            CustomButton(
              label: 'Refresh',
              className: 'action-btn primary',
              onPressed: () => _bloc.add(const FetchDashboardData()),
            ),
          ],
        ),

        if (status == Status.loading || status == Status.init)
          Container(
            className: 'dashboard-loading-container',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              gap: 16,
              children: [
                Container(className: 'loading-spinner'),
                const CustomText('Fetching latest analytics...'),
              ],
            ),
          )
        else if (status == Status.error)
          Container(
            className: 'error-container',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              gap: 12,
              children: [
                const CustomText('⚠️', className: 'error-icon', variant: TextVariant.h1),
                CustomText(
                  currentState.dashboardData.message ?? 'An error occurred',
                  className: 'error-message',
                  variant: TextVariant.bodySmall,
                  color: red,
                ),
                CustomButton(
                  label: 'Retry',
                  className: 'retry-btn',
                  onPressed: () => _bloc.add(const FetchDashboardData()),
                ),
              ],
            ),
          )
        else if (status == Status.success && currentState.dashboardData.value != null) ...[
          // Stats grid
          GridView(
            className: 'stats-grid',
            maxCrossAxisExtent: 220,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            shrinkWrap: true,
            children: [
              _statCard(
                '💰',
                TextUtils.totalRevenue,
                currentState.dashboardData.value!.stats.totalRevenue,
                '+20.1% from last month',
                green,
              ),
              _statCard(
                '📦',
                TextUtils.totalOrders,
                currentState.dashboardData.value!.stats.totalOrders,
                '+15.3% from last month',
                lightBlue,
              ),
              _statCard(
                '👥',
                TextUtils.activeUsers,
                currentState.dashboardData.value!.stats.activeUsers,
                '+4.5% from last month',
                violate,
              ),
              _statCard(
                '📈',
                TextUtils.growth,
                currentState.dashboardData.value!.stats.growth,
                '+201 since last hour',
                deepGreen,
              ),
              _statCard('🧂', 'Flavor', F.title, 'Flavor', deepBlue),
            ],
          ),

          // Quick actions
          Card(
            className: 'section-card',
            padding: const EdgeInsets.all(24.0),
            borderRadius: const BorderRadius.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  className: 'section-header',
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CustomText('Quick Actions', variant: TextVariant.h3),
                    CustomButton(
                      label: TextUtils.viewAll,
                      className: 'view-all-btn',
                      onPressed: () {},
                      isOutlined: true,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                GridView(
                  className: 'quick-grid',
                  maxCrossAxisExtent: 200,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  shrinkWrap: true,
                  children: [
                    _quickAction('📊', 'Analytics', 'View detailed reports'),
                    _quickAction('🛒', 'Orders', 'Manage your orders', route: RouteName.order),
                    _quickAction('🎮', 'Games', 'Play mini games', route: RouteName.games),
                    _quickAction('🏆', 'Leaderboard', 'Check rankings', route: RouteName.leaderBoard),
                    _quickAction('🛡️', 'Bio Data', 'Manage your profile', route: RouteName.bioData),
                    _quickAction('🗺️', 'Maps', 'Explore locations', route: RouteName.openStreetMap),
                  ],
                ),
              ],
            ),
          ),

          // Recent activity
          Card(
            className: 'section-card',
            padding: const EdgeInsets.all(24.0),
            borderRadius: const BorderRadius.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Row(
                  className: 'section-header',
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomText('Recent Activity', variant: TextVariant.h3),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  className: 'activity-list',
                  gap: 4,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: currentState.dashboardData.value!.activities
                      .map((act) => _activityItem(act.icon, act.title, act.description, act.time))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Component _statCard(String icon, String title, String value, String change, Color accent) {
    return Card(
      className: 'stat-card',
      padding: const EdgeInsets.all(20.0),
      borderRadius: const BorderRadius.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            className: 'stat-header',
            crossAxisAlignment: CrossAxisAlignment.center,
            gap: 10,
            children: [
              Container(
                className: 'stat-icon',
                width: 40,
                height: 40,
                alignment: Alignment.center,
                style: Styles(
                  raw: {
                    'background': 'linear-gradient(135deg, ${accent.value}20, ${accent.value}10)',
                  },
                ),
                child: CustomText(icon, variant: TextVariant.h3),
              ),
              CustomText(title, className: 'stat-title', variant: TextVariant.bodySmall),
            ],
          ),
          const SizedBox(height: 12),
          CustomText(value, className: 'stat-value', variant: TextVariant.h2, fontWeight: FontWeight.w700),
          const SizedBox(height: 4),
          CustomText(change, className: 'stat-change', variant: TextVariant.caption, color: accent),
        ],
      ),
    );
  }

  Component _quickAction(String icon, String title, String desc, {String? route}) {
    final actionCard = Container(
      className: 'quick-action',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        gap: 14,
        children: [
          Container(
            className: 'quick-icon',
            width: 44,
            height: 44,
            alignment: Alignment.center,
            child: CustomText(icon, variant: TextVariant.h3),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(title, className: 'quick-title', fontWeight: FontWeight.w600),
              CustomText(desc, className: 'quick-desc', variant: TextVariant.caption),
            ],
          ),
        ],
      ),
    );

    if (route != null) {
      return Link(to: route, child: actionCard);
    }
    return actionCard;
  }

  Component _activityItem(String dot, String title, String desc, String time) {
    return Container(
      className: 'activity-item',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        gap: 12,
        children: [
          CustomText(dot, className: 'activity-dot'),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(title, className: 'activity-title', fontWeight: FontWeight.w500),
                CustomText(desc, className: 'activity-desc', variant: TextVariant.caption),
              ],
            ),
          ),
          CustomText(time, className: 'activity-time', variant: TextVariant.caption),
        ],
      ),
    );
  }
}
