import 'package:equatable/equatable.dart';
import '../../../../core/models/dynamic_data.dart';
import '../../domain/entities/dashboard_data.dart';

class DashboardState extends Equatable {
  final DynamicBlocData<DashboardData> dashboardData;

  const DashboardState({
    required this.dashboardData,
  });

  factory DashboardState.initial() {
    return const DashboardState(
      dashboardData: DynamicBlocData<DashboardData>.init(),
    );
  }

  DashboardState copyWith({
    DynamicBlocData<DashboardData>? dashboardData,
  }) {
    return DashboardState(
      dashboardData: dashboardData ?? this.dashboardData,
    );
  }

  @override
  List<Object?> get props => [dashboardData.status];
}
