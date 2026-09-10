import 'package:bloc/bloc.dart';
import '../../../../core/models/dynamic_data.dart';
import '../../domain/usecases/get_dashboard_data.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardData getDashboardData;

  DashboardBloc({required this.getDashboardData})
      : super(DashboardState.initial()) {
    on<FetchDashboardData>(_onFetchDashboardData);
  }

  Future<void> _onFetchDashboardData(
    FetchDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(dashboardData: const DynamicBlocData.loading()));
    try {
      final data = await getDashboardData();
      emit(state.copyWith(dashboardData: DynamicBlocData.success(value: data)));
    } catch (e) {
      emit(state.copyWith(
        dashboardData: DynamicBlocData.error(
          message: 'Failed to load dashboard data. Please try again.',
        ),
      ));
    }
  }
}
