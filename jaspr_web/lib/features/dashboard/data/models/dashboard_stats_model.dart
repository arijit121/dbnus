import '../../domain/entities/dashboard_stats.dart';

class DashboardStatsModel extends DashboardStats {
  const DashboardStatsModel({
    required super.totalRevenue,
    required super.totalOrders,
    required super.activeUsers,
    required super.growth,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      totalRevenue: json['totalRevenue'] as String,
      totalOrders: json['totalOrders'] as String,
      activeUsers: json['activeUsers'] as String,
      growth: json['growth'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalRevenue': totalRevenue,
      'totalOrders': totalOrders,
      'activeUsers': activeUsers,
      'growth': growth,
    };
  }
}
