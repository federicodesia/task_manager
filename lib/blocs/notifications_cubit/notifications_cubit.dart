import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:task_manager/blocs/drifted_bloc/drifted_bloc.dart';
import 'package:task_manager/blocs/settings_cubit/settings_cubit.dart';
import 'package:task_manager/helpers/date_time_helper.dart';
import 'package:task_manager/models/dynamic_object.dart';
import 'package:task_manager/models/notification_data.dart';
import 'package:task_manager/models/notification_type.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/services/notification_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'notifications_state.dart';

part 'notifications_cubit.g.dart';

class NotificationsCubit extends DriftedCubit<NotificationsState> {

  final SettingsCubit settingsCubit;
  final NotificationService notificationService;

  NotificationsCubit({
    required this.settingsCubit,
    required this.notificationService
  }) : super(NotificationsState.initial);

  void scheduleTasksNotificatons(List<Task> tasks) async {
    final now = DateTime.now();
    const reminderType = NotificationType.reminder();

    final channelKey = notificationService.channels[reminderType]?.channelKey;
    if(channelKey == null) return;
    await AwesomeNotifications().cancelSchedulesByChannelKey(channelKey);

    emit(state.copyWith(
      notifications: state.notifications..removeWhere((notification){
        if(notification.type == reminderType){
          final scheduledAt = notification.scheduledAt;
          if(scheduledAt != null && scheduledAt.isAfter(now)) return true;
        }
        return false;
      })
    ));

    for (Task task in tasks) {
      final beforeSchedule = task.date.subtract(const Duration(minutes: 15));
      if(beforeSchedule.isAfter(now)){
        _scheduleTaskBeforeScheduleNotification(beforeSchedule, task.title);
      }

      final taskSchedule = task.date;
      if(taskSchedule.isAfter(now)){
        _scheduleTaskScheduleNotification(taskSchedule, task.title);
      }

      final uncompletedSchedule = task.date.add(const Duration(hours: 1));
      if(uncompletedSchedule.isAfter(now) && !task.isCompleted){
        _scheduleUncompletedTaskNotification(uncompletedSchedule, task.title);
      }
    }
  }

  void _createNotification(Future<NotificationData> Function(AppLocalizations) notificationData) async {
    try{
      final locale = settingsCubit.state.locale
        ?? AppLocalizations.supportedLocales.firstOrNull;
      if(locale == null) return;

      final localization = lookupAppLocalizations(locale);
      final data = await notificationData(localization);

      final channelKey = notificationService.channels[data.type]?.channelKey;
      if(channelKey == null) return;

      emit(state.copyWith(
        notifications: state.notifications..add(data)
      ));

      final scheduledAt = data.scheduledAt;
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: data.id,
          channelKey: channelKey,
          title: data.title,
          body: data.body
        ),
        schedule: scheduledAt != null ? NotificationCalendar.fromDate(date: scheduledAt) : null
      );
    }
    catch(_){}
  }

  void showLoginOnNewDeviceNotification() async{
    if(settingsCubit.state.loginOnNewDeviceNotification){

      _createNotification((localization) async{
        return await NotificationData.create(
          title: localization.notification_loginOnNewDevice_title,
          body: localization.notification_loginOnNewDevice_body,
          type: const NotificationType.security()
        );
      });
    }
  }

  void _scheduleTaskBeforeScheduleNotification(DateTime scheduleDate, String taskTitle) async{
    if(settingsCubit.state.beforeScheduleNotification){

      _createNotification((localization) async{
        return await NotificationData.create(
          title: taskTitle,
          body: localization.notification_beforeSchedule_body,
          type: const NotificationType.reminder(),
          scheduledAt: scheduleDate
        );
      });
    }
  }

  void _scheduleTaskScheduleNotification(DateTime scheduleDate, String taskTitle) async{
    if(settingsCubit.state.taskScheduleNotification){

      _createNotification((localization) async{
        return await NotificationData.create(
          title: taskTitle,
          body: localization.notification_taskSchedule_body,
          type: const NotificationType.reminder(),
          scheduledAt: scheduleDate
        );
      });
    }
  }

  void _scheduleUncompletedTaskNotification(DateTime scheduleDate, String taskTitle) async{
    if(settingsCubit.state.uncompletedTaskNotification){

      _createNotification((localization) async{
        return await NotificationData.create(
          title: taskTitle,
          body: localization.notification_uncompletedTask_body,
          type: const NotificationType.reminder(),
          scheduledAt: scheduleDate
        );
      });
    }
  }

  @override
  Future<void> close() {
    // Delete notifications older than a week.
    final now = DateTime.now();
    emit(state.copyWith(notifications: state.notifications..removeWhere((n){
      return now.dateDifference(n.createdAt) > 7;
    })));
    return super.close();
  }

  @override
  NotificationsState? fromJson(Map<String, dynamic> json) {
    try{
      debugPrint("NotificationsCubit fromJson");
      return NotificationsState.fromJson(json);
    }
    catch(error) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(NotificationsState state) {
    try{
      debugPrint("NotificationsCubit toJson");
      return state.toJson();
    }
    catch(error) {
      return null;
    }
  }
}