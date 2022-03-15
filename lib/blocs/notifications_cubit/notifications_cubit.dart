import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:task_manager/blocs/drifted_bloc/drifted_bloc.dart';
import 'package:task_manager/models/notification_data.dart';

part 'notifications_state.dart';

part 'notifications_cubit.g.dart';

class NotificationsCubit extends DriftedCubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsState());

  @override
  NotificationsState? fromJson(Map<String, dynamic> json) {
    try{
      debugPrint("SettNotificationsCubitingCubit fromJson");
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