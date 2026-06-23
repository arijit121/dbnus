import 'dart:async';
import 'package:jaspr/dom.dart' hide BorderRadius;
import 'package:jaspr/jaspr.dart';

import '../../../../shared/constants/theme.dart';
import '../../../../core/models/dynamic_data.dart';
import '../../data/datasources/dashboard_remote_data_source.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/usecases/get_dashboard_data.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../../../../shared/ui/ui.dart';
import '../../../../shared/constants/assects_const.dart';

import '../widgets/welcome_header.dart';
import '../widgets/quick_actions_grid.dart';
import '../widgets/tools_section.dart';
import '../widgets/payment_section.dart';
import '../widgets/media_section.dart';
import '../widgets/section_title.dart';

class DashboardPage extends StatefulComponent {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final DashboardBloc _bloc;
  late final StreamSubscription<DashboardState> _subscription;
  DashboardState _state = DashboardState.initial();
  final ValueNotifier<int> counter = ValueNotifier(0);

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _midController = TextEditingController();
  final TextEditingController _orderIdController = TextEditingController();
  final TextEditingController _txnTokenController = TextEditingController();

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
    _amountController.dispose();
    _midController.dispose();
    _orderIdController.dispose();
    _txnTokenController.dispose();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    final currentState = _state;
    final status = currentState.dashboardData.status;

    return Column(
      className: 'dashboard',
      gap: 28,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Welcome header (Always visible, matching the Flutter welcome header card)
        WelcomeHeader(counter: counter),

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
                CustomGOEButton(
                  child: text('Retry'),
                  className: 'retry-btn',
                  backGroundColor: baseHexColor,
                  onPressed: () => _bloc.add(const FetchDashboardData()),
                ),
              ],
            ),
          )
        else if (status == Status.success && currentState.dashboardData.value != null) ...[
          // Quick Actions
          const SectionTitle(title: "Quick Actions", icon: AssetsConst.featherZap),
          const QuickActionsGrid(),

          // Tools & Utilities
          const SectionTitle(title: "Tools & Utilities", icon: AssetsConst.featherTool),
          const ToolsSection(),

          // Payment Gateway
          const SectionTitle(title: "Payment Gateway", icon: AssetsConst.featherCreditCard),
          PaymentSection(
            amountController: _amountController,
            midController: _midController,
            orderIdController: _orderIdController,
            txnTokenController: _txnTokenController,
          ),

          // Media Gallery
          const SectionTitle(title: "Media Gallery", icon: AssetsConst.featherImage),
          const MediaSection(),
        ],
      ],
    );
  }
}
