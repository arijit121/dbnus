import 'package:dbnus/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:dbnus/features/dashboard/domain/repositories/dashboard_repository.dart';

import '../datasources/dashboard_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardDataSource dataSource;

  DashboardRepositoryImpl({required this.dataSource});

  @override
  Future<DashboardData?> getDashboardData() async {
    return await dataSource.getDashboardData();
  }
}
