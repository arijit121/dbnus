import 'package:equatable/equatable.dart';

class DashboardStats extends Equatable {
  final String totalRevenue;
  final String totalOrders;
  final String activeUsers;
  final String growth;

  const DashboardStats({
    required this.totalRevenue,
    required this.totalOrders,
    required this.activeUsers,
    required this.growth,
  });

  @override
  List<Object?> get props => [totalRevenue, totalOrders, activeUsers, growth];
}
