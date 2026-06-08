import '../../domain/entities/dashboard_data.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  const DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DashboardData> getDashboardData() async {
    final stats = await remoteDataSource.getStats();
    final activities = await remoteDataSource.getActivities();
    return DashboardData(stats: stats, activities: activities);
  }
}
