import 'package:flutter/material.dart';
import 'package:task_manager/l10n/l10n.dart';

enum NotificationType { general, reminder, security, advertisement }

extension NotificationTypeExtension on NotificationType? {
  String nameLocalization(BuildContext context, {bool isPlural = false}) {
    final countValue = isPlural ? 2 : 1;
    if(this == null) return context.l10n.enum_notificationType_all;
    if(this == NotificationType.reminder) return context.l10n.enum_notificationType_reminder(countValue);
    if(this == NotificationType.advertisement) return context.l10n.enum_notificationType_advertisement(countValue);
    return "Unknown";
  }
}