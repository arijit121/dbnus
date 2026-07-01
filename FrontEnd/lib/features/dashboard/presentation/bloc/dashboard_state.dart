part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  final DynamicBlocData<int> counter;
  final DynamicBlocData<DashboardData> dashboardData;

  const DashboardState({
    required this.counter,
    required this.dashboardData,
  });

  factory DashboardState.initial() {
    return const DashboardState(
      counter: DynamicBlocData<int>.success(value: 0),
      dashboardData: DynamicBlocData<DashboardData>.init(),
    );
  }

  DashboardState copyWith({
    DynamicBlocData<int>? counter,
    DynamicBlocData<DashboardData>? dashboardData,
  }) {
    return DashboardState(
      counter: counter ?? this.counter,
      dashboardData: dashboardData ?? this.dashboardData,
    );
  }

  @override
  List<Object> get props => [counter.status, dashboardData.status];
}
