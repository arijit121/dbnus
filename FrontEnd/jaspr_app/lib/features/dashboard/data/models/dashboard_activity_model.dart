import '../../domain/entities/dashboard_activity.dart';

class DashboardActivityModel extends DashboardActivity {
  const DashboardActivityModel({
    required super.icon,
    required super.title,
    required super.description,
    required super.time,
  });

  factory DashboardActivityModel.fromJson(Map<String, dynamic> json) {
    return DashboardActivityModel(
      icon: json['icon'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      time: json['time'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'icon': icon,
      'title': title,
      'description': description,
      'time': time,
    };
  }
}
