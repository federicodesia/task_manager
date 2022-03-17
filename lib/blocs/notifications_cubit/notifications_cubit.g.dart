// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationsState _$NotificationsStateFromJson(Map<String, dynamic> json) =>
    NotificationsState(
      notifications: (json['notifications'] as List<dynamic>)
          .map((e) => NotificationData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NotificationsStateToJson(NotificationsState instance) =>
    <String, dynamic>{
      'notifications': instance.notifications,
    };
