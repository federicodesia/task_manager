import 'package:flutter/material.dart';
import 'package:task_manager/l10n/l10n.dart';

enum NotificationType { general, reminder, security }
enum NotificationTypeFilter { all, reminders, advertisements }

extension NotificationTypeFilterExtension on NotificationTypeFilter {
  String nameLocalization(BuildContext context) {
    if(this == NotificationTypeFilter.all) return context.l10n.enum_notificationTypeFilter_all;
    if(this == NotificationTypeFilter.reminders) return context.l10n.enum_notificationTypeFilter_reminders;
    if(this == NotificationTypeFilter.advertisements) return context.l10n.enum_notificationTypeFilter_advertisements;
    return "Unknown";
  }
}