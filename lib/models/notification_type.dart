import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:task_manager/l10n/l10n.dart';
import 'package:task_manager/models/serializers/color_serializer.dart';

part 'notification_type.freezed.dart';
part 'notification_type.g.dart';

@freezed
class NotificationType with _$NotificationType{

  const factory NotificationType.general({
    @ColorSerializer()
    @Default(Color(0xFF008FFD))
    Color color
  }) = GeneralNotification;

  const factory NotificationType.reminder({
    @ColorSerializer()
    @Default(Color(0xFF5C5D9D))
    Color color
  }) = ReminderNotification;

  const factory NotificationType.security({
    @ColorSerializer()
    @Default(Color(0xFFFF8700))
    Color color
  }) = SecurityNotification;

  const factory NotificationType.advertisement({
    @ColorSerializer()
    @Default(Color(0xFFFFBF47))
    Color color
  }) = AdvertisementNotification;

  factory NotificationType.fromJson(Map<String, dynamic> json) => _$NotificationTypeFromJson(json);
}

extension NotificationTypeExtension on NotificationType? {
  String nameLocalization(BuildContext context, {bool isPlural = false}) {
    final countValue = isPlural ? 2 : 1;
    if(this == null) return context.l10n.enum_notificationType_all;
    if(this is ReminderNotification) return context.l10n.enum_notificationType_reminder(countValue);
    if(this is AdvertisementNotification) return context.l10n.enum_notificationType_advertisement(countValue);
    return "Unknown";
  }
}