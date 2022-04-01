import 'dart:async';
import 'dart:io';

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

  StreamSubscription<ReceivedNotification>? displayedNotificationsSubscription;

  NotificationsCubit({
    required this.settingsCubit,
    required this.notificationService
  }) : super(NotificationsState.initial){

    // Delete notifications older than a week.
    final now = DateTime.now();
    emit(state.copyWith(notifications: state.notifications..removeWhere((n){
      return now.differenceInDays(n.createdAt) > 7;
    })));

    displayedNotificationsSubscription = notificationService.displayedStream
      .listen((notification) => emit(state.copyWith()));
  }

  void markAsRead(NotificationData notification){
    emit(state.copyWith(
      notifications: state.notifications
        ..removeWhere((n) => n == notification)
    ));
  }

  void undoMarkAsRead(NotificationData notification){
    emit(state.copyWith(
      notifications: state.notifications..add(notification)
    ));
  }

  void cancelAll() async {
    await AwesomeNotifications().cancelAll();
    emit(NotificationsState.initial);
  }

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
        await _scheduleTaskBeforeScheduleNotification(beforeSchedule, task.title);
      }

      final taskSchedule = task.date;
      if(taskSchedule.isAfter(now)){
        await _scheduleTaskScheduleNotification(taskSchedule, task.title);
      }

      final uncompletedSchedule = task.date.add(const Duration(hours: 1));
      if(uncompletedSchedule.isAfter(now) && !task.isCompleted){
        await _scheduleUncompletedTaskNotification(uncompletedSchedule, task.title);
      }
    }
  }

  Future<void> _createNotification(Future<NotificationData> Function(AppLocalizations) notificationData) async {
    try{
      AppLocalizations? localization;
      try{
        final locale = settingsCubit.state.locale ?? Locale(Platform.localeName.split("_").first);
        localization = lookupAppLocalizations(locale);
      }
      catch(_){
        final locale = AppLocalizations.supportedLocales.firstOrNull;
        if(locale != null) localization = lookupAppLocalizations(locale);
      }

      if(localization == null) return;
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

  Future<void> showLoginOnNewDeviceNotification() async{
    if(settingsCubit.state.loginOnNewDeviceNotification){

      await _createNotification((localization) async{
        return await NotificationData.create(
          title: localization.notification_loginOnNewDevice_title,
          body: localization.notification_loginOnNewDevice_body,
          type: const NotificationType.security()
        );
      });
    }
  }

  Future<void> _scheduleTaskBeforeScheduleNotification(DateTime scheduleDate, String taskTitle) async{
    if(settingsCubit.state.beforeScheduleNotification){

      await _createNotification((localization) async{
        return await NotificationData.create(
          title: taskTitle,
          body: localization.notification_beforeSchedule_body,
          type: const NotificationType.reminder(),
          scheduledAt: scheduleDate
        );
      });
    }
  }

  Future<void> _scheduleTaskScheduleNotification(DateTime scheduleDate, String taskTitle) async{
    if(settingsCubit.state.taskScheduleNotification){

      await _createNotification((localization) async{
        return await NotificationData.create(
          title: taskTitle,
          body: localization.notification_taskSchedule_body,
          type: const NotificationType.reminder(),
          scheduledAt: scheduleDate
        );
      });
    }
  }

  Future<void> _scheduleUncompletedTaskNotification(DateTime scheduleDate, String taskTitle) async{
    if(settingsCubit.state.uncompletedTaskNotification){

      await _createNotification((localization) async{
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
  Future<void> close() async {
    await displayedNotificationsSubscription?.cancel();
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