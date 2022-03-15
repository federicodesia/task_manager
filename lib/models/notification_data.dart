import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_data.g.dart';

enum NotificationType { reminder, security, other }
enum NotificationTypeFilter { all, reminders }

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

extension NotificationTypeExtension on NotificationType {
  // TODO: Internationalize
  String nameLocalization(BuildContext context) {
    if(this == NotificationType.reminder) return "";
    if(this == NotificationType.security) return "";
    if(this == NotificationType.other) return "";
    return "Unknown";
  }
}

extension NotificationTypeFilterExtension on NotificationTypeFilter {
  // TODO: Internationalize
  String nameLocalization(BuildContext context) {
    if(this == NotificationTypeFilter.all) return "";
    if(this == NotificationTypeFilter.reminders) return "";
    return "Unknown";
  }
}