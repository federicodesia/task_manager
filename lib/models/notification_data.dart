import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:task_manager/models/notification_type.dart';
import 'package:collection/collection.dart';

part 'notification_data.g.dart';

@JsonSerializable()
class NotificationData{

  final int id;
  final String title;
  final String body;
  final DateTime createdAt;
  final DateTime? scheduledAt;
  final NotificationType type;

  const NotificationData({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.scheduledAt,
    required this.type
  });

  static Future<NotificationData> create({
    required String title,
    required String body,
    DateTime? scheduledAt,
    required NotificationType type
  }) async {
    final scheduledNotifications = await AwesomeNotifications().listScheduledNotifications();

    scheduledNotifications.sort((a, b) {
      final idA = a.content?.id;
      final idB = b.content?.id;

      if(idA != null && idB != null){
        if(idA > idB) return 1;
        if(idA < idB) return -1;
        return 0;
      }
      
      if(idA == null && idB != null) return -1;
      if(idA != null && idB == null) return 1;
      return 0;
    });

    final lastId = scheduledNotifications.lastOrNull?.content?.id;
    final id = lastId != null ? lastId + 1 : 0;

    return NotificationData(
      id: id,
      title: title,
      body: body,
      createdAt: DateTime.now(),
      type: type,
      scheduledAt: scheduledAt
    );
  }

  factory NotificationData.fromJson(Map<String, dynamic> json) => _$NotificationDataFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationDataToJson(this);
}