import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:task_manager/blocs/drifted_bloc/drifted_bloc.dart';
import 'package:task_manager/models/serializers/locale_serializer.dart';

part 'settings_state.dart';

part 'settings_cubit.g.dart';

class SettingsCubit extends DriftedCubit<SettingsState> {

  final _taskNotificationsConfigChangeController = StreamController<void>.broadcast();
  Stream<void> get taskNotificationsConfigChange => _taskNotificationsConfigChangeController.stream;
  
  SettingsCubit() : super(SettingsState());

  void toggleThemeMode(BuildContext context){
    final brightness = Theme.of(context).brightness;
    emit(state.copyWith(
      themeMode: brightness == Brightness.dark
        ? ThemeMode.light
        : ThemeMode.dark
      )
    );
  }

  void changeLocale(Locale? locale) => emit(state.copyWith(locale: locale));

  void toggleBeforeScheduleNotification(){
    emit(state.copyWith(beforeScheduleNotification: !state.beforeScheduleNotification));
    _taskNotificationsConfigChangeController.add(null);
  }

  void toggleTaskScheduleNotification(){
    emit(state.copyWith(taskScheduleNotification: !state.taskScheduleNotification));
    _taskNotificationsConfigChangeController.add(null);
  }

  void toggleUncompletedTaskNotification(){
    emit(state.copyWith(uncompletedTaskNotification: !state.uncompletedTaskNotification));
    _taskNotificationsConfigChangeController.add(null);
  }

  void toggleNewUpdatesAvailableNotification(){
    emit(state.copyWith(newUpdatesAvailableNotification: !state.newUpdatesAvailableNotification));
  }

  void toggleAnnouncementsAndOffersNotification(){
    emit(state.copyWith(announcementsAndOffersNotification: !state.announcementsAndOffersNotification));
  }

  void toggleLoginOnNewDeviceNotification(){
    emit(state.copyWith(loginOnNewDeviceNotification: !state.loginOnNewDeviceNotification));
  }

  @override
  SettingsState? fromJson(Map<String, dynamic> json) {
    try{
      debugPrint("SettingCubit fromJson");
      return SettingsState.fromJson(json);
    }
    catch(error) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(SettingsState state) {
    try{
      debugPrint("SettingCubit toJson");
      return state.toJson();
    }
    catch(error) {
      return null;
    }
  }
}