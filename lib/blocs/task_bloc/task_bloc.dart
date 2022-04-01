import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/blocs/drifted_bloc/drifted_bloc.dart';
import 'package:task_manager/blocs/notifications_cubit/notifications_cubit.dart';
import 'package:task_manager/models/sync_item_error.dart';
import 'package:task_manager/models/sync_status.dart';
import 'package:task_manager/models/task.dart';

part 'task_event.dart';
part 'task_state.dart';

part 'task_bloc.g.dart';

class TaskBloc extends DriftedBloc<TaskEvent, TaskState> {

  final bool inBackground;
  final AuthBloc authBloc;
  final NotificationsCubit notificationsCubit;

  StreamSubscription<void>? taskNotificationsConfigChangeSubscription;

  TaskBloc({
    required this.inBackground,
    required this.authBloc,
    required this.notificationsCubit
  }) : super(TaskState.initial){

    taskNotificationsConfigChangeSubscription = notificationsCubit.settingsCubit
      .taskNotificationsConfigChange.listen((_) => add(ScheduleTaskNotificationsRequested()));
    
    on<TaskLoaded>((event, emit) {

      final currentUserId = authBloc.state.user?.id;
      if(state.userId != currentUserId){
        emit(TaskState.initial.copyWith(
          isLoading: false,
          userId: currentUserId,
          syncStatus: SyncStatus.idle
        ));
      }

      if(!inBackground){
        emit(state.copyWith(
          isLoading: true,
          syncStatus: SyncStatus.pending
        ));
      }
    });
    add(TaskLoaded());

    on<TaskAdded>((event, emit) async{
      final taskState = state;
      emit(taskState.copyWith(tasks: taskState.tasks..add(event.task)));
    });

    on<TaskUpdated>((event, emit){
      final taskState = state;
      emit(taskState.copyWith(tasks: taskState.tasks.map((task){
        return task.id == event.task.id ? event.task : task;
      }).toList()));
    });

    on<TaskDeleted>((event, emit){
      final taskState = state;
      emit(taskState.copyWith(
        tasks: taskState.tasks..removeWhere((t) => t.id == event.task.id),
        deletedTasks: taskState.deletedTasks..add(event.task.copyWith(deletedAt: DateTime.now()))
      ));
    });

    on<TaskUndoDeleted>((event, emit){
      final taskState = state;
      emit(taskState.copyWith(
        tasks: taskState.tasks..add(event.task.copyWith(deletedAt: null)),
        deletedTasks: taskState.deletedTasks..removeWhere((t) => t.id == event.task.id)
      ));
    });
    
    on<TasksUpdated>((event, emit){
      emit(state.copyWith(tasks: event.tasks));
    });

    on<TaskStateUpdated>((event, emit){
      debugPrint("Actualizando TaskState...");
      emit(event.state.copyWith(
        isLoading: false,
        syncStatus: event.state.syncStatus
      ));
    },
    transformer: restartable());

    on<ScheduleTaskNotificationsRequested>((event, emit){
      notificationsCubit.scheduleTasksNotificatons(state.tasks);
    });
  }

  @override
  void onChange(change) async {
    super.onChange(change);
    add(ScheduleTaskNotificationsRequested());
  }

  @override
  Future<void> close() async {
    await taskNotificationsConfigChangeSubscription?.cancel();
    return super.close();
  }

  @override
  TaskState? fromJson(Map<String, dynamic> json) {
    try{
      debugPrint("TaskBloc fromJson");
      return TaskState.fromJson(json);
    }
    catch(error) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(TaskState state) {
    try{
      debugPrint("TaskBloc toJson");
      return state.toJson();
    }
    catch(error) {
      return null;
    }
  }
}