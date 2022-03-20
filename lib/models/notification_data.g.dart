// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationData _$NotificationDataFromJson(Map<String, dynamic> json) =>
    NotificationData(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$NotificationDataToJson(NotificationData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'createdAt': instance.createdAt.toIso8601String(),
      'type': _$NotificationTypeEnumMap[instance.type],
    };

const _$NotificationTypeEnumMap = {
  NotificationType.general: 'general',
  NotificationType.reminder: 'reminder',
  NotificationType.security: 'security',
  NotificationType.advertisement: 'advertisement',
};
