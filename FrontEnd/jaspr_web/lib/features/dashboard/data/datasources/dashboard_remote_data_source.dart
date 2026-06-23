import '../models/dashboard_stats_model.dart';
import '../models/dashboard_activity_model.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardStatsModel> getStats();
  Future<List<DashboardActivityModel>> getActivities();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  @override
  Future<DashboardStatsModel> getStats() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const DashboardStatsModel(
      totalRevenue: '\$45,231',
      totalOrders: '2,350',
      activeUsers: '12,234',
      growth: '+573',
    );
  }

  @override
  Future<List<DashboardActivityModel>> getActivities() async {
    return const [
      DashboardActivityModel(
        icon: '🟢',
        title: 'New order received',
        description: 'Order #1234 from John Doe',
        time: '2 min ago',
      ),
      DashboardActivityModel(
        icon: '🔵',
        title: 'Payment completed',
        description: '\$350.00 payment processed',
        time: '15 min ago',
      ),
      DashboardActivityModel(
        icon: '🟡',
        title: 'New user registered',
        description: 'jane.doe@email.com joined',
        time: '1 hour ago',
      ),
      DashboardActivityModel(
        icon: '🟣',
        title: 'Report generated',
        description: 'Monthly analytics report ready',
        time: '3 hours ago',
      ),
      DashboardActivityModel(
        icon: '🔴',
        title: 'Server alert',
        description: 'High CPU usage detected',
        time: '5 hours ago',
      ),
    ];
  }
}
