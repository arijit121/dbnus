import 'package:dbnus/features/dashboard/data/models/dashboard_data_response.dart';
import 'dashboard_data_source.dart';

class DashboardMockDataSource implements DashboardDataSource {
  @override
  Future<DashboardDataResponse?> getDashboardData() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return DashboardDataResponse(
      welcomeMessage: "Welcome to Dbnus Showcase Dashboard!",
      activeUsersCount: 1420,
      notifications: [
        "System maintenance scheduled for tonight at 12:00 AM.",
        "Your recent transaction of \$100 was successful.",
        "Check out the new game dashboard features!",
      ],
    );
  }
}
