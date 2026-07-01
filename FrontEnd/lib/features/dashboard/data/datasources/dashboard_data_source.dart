import 'package:dbnus/features/dashboard/data/models/dashboard_data_response.dart';

abstract class DashboardDataSource {
  Future<DashboardDataResponse?> getDashboardData();
}
