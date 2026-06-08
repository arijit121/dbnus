import 'package:equatable/equatable.dart';

class DashboardActivity extends Equatable {
  final String icon;
  final String title;
  final String description;
  final String time;

  const DashboardActivity({
    required this.icon,
    required this.title,
    required this.description,
    required this.time,
  });

  @override
  List<Object?> get props => [icon, title, description, time];
}
