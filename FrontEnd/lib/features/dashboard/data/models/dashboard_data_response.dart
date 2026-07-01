import 'package:dbnus/features/dashboard/domain/entities/dashboard_data.dart';

class DashboardDataResponse extends DashboardData {
  DashboardDataResponse({
    super.welcomeMessage,
    super.activeUsersCount,
    super.notifications,
  });

  DashboardDataResponse.fromJson(Map<String, dynamic> json) {
    welcomeMessage = json['welcomeMessage'] as String?;
    activeUsersCount = json['activeUsersCount'] as int?;
    notifications = (json['notifications'] as List<dynamic>?)?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['welcomeMessage'] = welcomeMessage;
    data['activeUsersCount'] = activeUsersCount;
    data['notifications'] = notifications;
    return data;
  }
}
