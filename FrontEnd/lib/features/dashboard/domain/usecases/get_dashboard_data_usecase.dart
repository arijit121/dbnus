import 'package:dbnus/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:dbnus/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetDashboardDataUseCase {
  final DashboardRepository repository;

  GetDashboardDataUseCase(this.repository);

  Future<DashboardData?> call() async {
    return await repository.getDashboardData();
  }
}
