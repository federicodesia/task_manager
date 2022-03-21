import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:task_manager/blocs/drifted_bloc/drifted_bloc.dart';
import 'package:task_manager/blocs/settings_cubit/settings_cubit.dart';
import 'package:task_manager/helpers/date_time_helper.dart';
import 'package:task_manager/models/dynamic_object.dart';
import 'package:task_manager/models/notification_data.dart';
import 'package:task_manager/models/notification_type.dart';
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

  void _showNotification(NotificationData Function(AppLocalizations) notificationData) async {
    try{
      final locale = settingsCubit.state.locale
        ?? AppLocalizations.supportedLocales.firstOrNull;
      if(locale == null) return;

      final localization = lookupAppLocalizations(locale);
      final data = notificationData(localization);

      final channelKey = notificationService.channels[data.type]?.channelKey;
      if(channelKey == null) return;

      emit(state.copyWith(
        notifications: state.notifications..add(data)
      ));

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: data.id,
          channelKey: channelKey,
          title: data.title,
          body: data.body
        ),
      );
    }
    catch(_){}
  }

  void showLoginOnNewDeviceNotification() async{
    if(settingsCubit.state.loginOnNewDeviceNotification){

      _showNotification((localization){
        return NotificationData(
          id: state.notifications.length,
          title: localization.notification_loginOnNewDevice_title,
          body: localization.notification_loginOnNewDevice_body,
          createdAt: DateTime.now(),
          type: const NotificationType.security()
        );
      });
    }
  }

  void showTaskBeforeScheduleNotification(String taskTitle) async{
    if(settingsCubit.state.beforeScheduleNotification){

      _showNotification((localization){
        return NotificationData(
          id: state.notifications.length,
          title: taskTitle,
          body: localization.notification_beforeSchedule_body,
          createdAt: DateTime.now(),
          type: const NotificationType.reminder()
        );
      });
    }
  }

  void showTaskScheduleNotification(String taskTitle) async{
    if(settingsCubit.state.taskScheduleNotification){

      _showNotification((localization){
        return NotificationData(
          id: state.notifications.length,
          title: taskTitle,
          body: localization.notification_taskSchedule_body,
          createdAt: DateTime.now(),
          type: const NotificationType.reminder()
        );
      });
    }
  }

  void showUncompletedTaskNotification(String taskTitle) async{
    if(settingsCubit.state.uncompletedTaskNotification){
      
      _showNotification((localization){
        return NotificationData(
          id: state.notifications.length,
          title: taskTitle,
          body: localization.notification_uncompletedTask_body,
          createdAt: DateTime.now(),
          type: const NotificationType.reminder()
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