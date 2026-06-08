import '../entities/dashboard_data.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardData {
  final DashboardRepository repository;

  const GetDashboardData(this.repository);

  Future<DashboardData> call() async {
    return repository.getDashboardData();
  }
}
