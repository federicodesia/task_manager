import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:task_manager/blocs/drifted_bloc/drifted_bloc.dart';
import 'package:task_manager/blocs/notifications_cubit/notifications_cubit.dart';
import 'package:task_manager/models/sync_item_error.dart';
import 'package:task_manager/models/sync_status.dart';
import 'package:task_manager/models/task.dart';

part 'task_event.dart';
part 'task_state.dart';

part 'task_bloc.g.dart';

class TaskBloc extends DriftedBloc<TaskEvent, TaskState> {

  final NotificationsCubit notificationsCubit;

  StreamSubscription<void>? taskNotificationsConfigChangeSubscription;

  TaskBloc({
    required this.notificationsCubit
  }) : super(TaskLoadSuccess.initial){

    taskNotificationsConfigChangeSubscription = notificationsCubit.settingsCubit
      .taskNotificationsConfigChange.listen((_) => add(ScheduleTaskNotificationsRequested()));

    on<TaskAdded>((event, emit) async{
      final taskState = state;
      if(taskState is TaskLoadSuccess){
        emit(taskState.copyWith(tasks: taskState.tasks..add(event.task)));
      }
    });

    on<TaskUpdated>((event, emit){
      final taskState = state;
      if(taskState is TaskLoadSuccess){
        emit(taskState.copyWith(tasks: taskState.tasks.map((task){
          return task.id == event.task.id ? event.task : task;
        }).toList()));
      }
    });

    on<TaskDeleted>((event, emit){
      final taskState = state;
      if(taskState is TaskLoadSuccess){
        emit(taskState.copyWith(
          tasks: taskState.tasks..removeWhere((t) => t.id == event.task.id),
          deletedTasks: taskState.deletedTasks..add(event.task.copyWith(deletedAt: DateTime.now()))
        ));
      }
    });

    on<TaskUndoDeleted>((event, emit){
      final taskState = state;
      if(taskState is TaskLoadSuccess){
        emit(taskState.copyWith(
          tasks: taskState.tasks..add(event.task.copyWith(deletedAt: null)),
          deletedTasks: taskState.deletedTasks..removeWhere((t) => t.id == event.task.id)
        ));
      }
    });
    
    on<TasksUpdated>((event, emit){
      final taskState = state;
      if(taskState is TaskLoadSuccess){
        emit(taskState.copyWith(tasks: event.tasks));
      }
    });

    on<TaskStateUpdated>((event, emit){
      debugPrint("Actualizando TaskState...");
      final taskState = event.state;
      if(taskState is TaskLoadSuccess){
        debugPrint("SyncPushStatus: " + taskState.syncPushStatus.name);
        debugPrint("Tasks: ${taskState.tasks}");
        debugPrint("DeletedTasks: ${taskState.deletedTasks}");
        debugPrint("FailedTasks: ${taskState.failedTasks}");
      }
      emit(event.state);
    },
    transformer: restartable());

    on<ScheduleTaskNotificationsRequested>((event, emit){
      final taskState = state;
      if(taskState is TaskLoadSuccess){
        notificationsCubit.scheduleTasksNotificatons(taskState.tasks);
      }
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
      debugPrint("taskBloc fromJson");
      return TaskLoadSuccess.fromJson(json);
    }
    catch(error) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(TaskState state) {
    try{
      debugPrint("taskBloc toJson");
      final taskState = state;
      if(taskState is TaskLoadSuccess) return taskState.toJson();
    }
    catch(error) {
      return null;
    }
    return null;
  }
}