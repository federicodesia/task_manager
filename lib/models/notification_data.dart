import 'package:json_annotation/json_annotation.dart';
import 'package:task_manager/models/notification_type.dart';

part 'notification_data.g.dart';

@JsonSerializable()
class NotificationData{

  final int id;
  final String title;
  final String body;
  final DateTime createdAt;
  final NotificationType type;

  const NotificationData({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.type
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) => _$NotificationDataFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationDataToJson(this);
}