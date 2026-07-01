part of 'dashboard_bloc.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class Init extends DashboardEvent {}

class GetDashboardData extends DashboardEvent {}

class IncrementCounter extends DashboardEvent {}
