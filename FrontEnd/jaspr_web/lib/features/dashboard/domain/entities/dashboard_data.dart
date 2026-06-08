import 'package:equatable/equatable.dart';
import 'dashboard_stats.dart';
import 'dashboard_activity.dart';

class DashboardData extends Equatable {
  final DashboardStats stats;
  final List<DashboardActivity> activities;

  const DashboardData({
    required this.stats,
    required this.activities,
  });

  @override
  List<Object?> get props => [stats, activities];
}
