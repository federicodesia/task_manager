import 'dart:convert';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_manager/helpers/date_time_helper.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/repositories/task_repository.dart';
import 'package:collection/collection.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends HydratedBloc<TaskEvent, TaskState> {

  final TaskRepository taskRepository;
  TaskBloc({required this.taskRepository}) : super(TaskLoadInProgress()){

    on<TaskLoaded>((event, emit) async{
      /*final tasks = await taskRepository.getTasks();
      if(tasks != null) emit(TaskLoadSuccess(tasks));
      else emit(TaskLoadFailure());*/
      //add(TaskSyncPullRequested());
    });

    on<TaskAdded>((event, emit) async{
      final taskState = state;
      if(taskState is TaskLoadSuccess){
        emit(taskState.copyWith(tasks: taskState.tasks..add(event.task)));
        add(TaskSyncPushRequested());
      }
    });

    on<TaskUpdated>((event, emit){
      final taskState = state;
      if(taskState is TaskLoadSuccess){
        emit(taskState.copyWith(tasks: taskState.tasks.map((task){
          return task.id == event.task.id ? event.task : task;
        }).toList()));
        add(TaskSyncPushRequested());
      }
    });

    on<TaskDeleted>((event, emit){
      final taskState = state;
      if(taskState is TaskLoadSuccess){
        emit(taskState.copyWith(tasks: taskState.tasks
          .where((task) => task.id != event.task.id).toList()));
        add(TaskSyncPushRequested());
      }
    });

    on<TaskSyncPullRequested>((event, emit) async{
      final taskState = state;

      if(taskState is TaskLoadSuccess){
        print("SyncPull requested");
        final tasks = await taskRepository.syncPull(lastSync: taskState.lastSyncPull);
        print("Tasks: $tasks");
        if(tasks != null){
          
          final newTaskState = state;
          if(newTaskState is TaskLoadSuccess){

            final modifiedTasks = newTaskState.tasks.where((n){
              final pulledTask = tasks.firstWhereOrNull((t) => t.id == n.id);
              if(pulledTask != null) return n.updatedAt.isAfter(pulledTask.updatedAt);
              return false;
            }).toList();
            print("ModifiedTasks: $modifiedTasks");

            final updatedTasks = tasks..removeWhere((t){
              final modifiedTask = modifiedTasks.firstWhereOrNull((m) => m.id == t.id);
              return modifiedTask != null ? true : false;
            });
            print("UpdatedTasks: $updatedTasks");

            final result = newTaskState.tasks.map((t){
              final updatedTask = updatedTasks.firstWhereOrNull((u) => u.id == t.id);
              return updatedTask ?? t;
            }).toList();

            updatedTasks.forEach((u) {
              if(result.firstWhereOrNull((t) => t.id == u.id) == null) result.add(u);
            });

            print("Result: $result");

            emit(newTaskState.copyWith(
              lastSyncPull: DateTime.now(),
              tasks: result
            ));
          }
        }
      }
    });

    on<TaskSyncPushRequested>((event, emit) async{
      final taskState = state;
      print("SyncPush requested");

      if(taskState is TaskLoadSuccess){

        final lastSyncPush = taskState.lastSyncPush;
        final updatedTasks;

        if(lastSyncPush != null) updatedTasks = taskState.tasks.where((t) => t.updatedAt.isAfter(lastSyncPush)).toList();
        else updatedTasks = taskState.tasks;
        print("UpdatedTasks: $updatedTasks");
        
        final tasks = await taskRepository.syncPush(tasks: updatedTasks);
        print("Tasks: ${jsonEncode(tasks)}");

        if(tasks != null){
          emit(taskState.copyWith(
            lastSyncPush: DateTime.now(),
            tasks: taskState.tasks.map((t){
              final pushedTask = tasks.firstWhereOrNull((p) => p.id == t.id);
              return pushedTask ?? t;
            }).toList()
          ));
        }
      }
    });

    on<TasksUpdated>((event, emit){
      final taskState = state;
      if(taskState is TaskLoadSuccess){
        emit(taskState.copyWith(tasks: event.tasks));
      }
    });
  }

  @override
  TaskState? fromJson(Map<String, dynamic> json) {
    print("fromJson");
    try{
      final lastSyncPullString = json["lastSyncPull"];
      final lastSyncPushString = json["lastSyncPush"];

      final tasks = List<Task>.from(jsonDecode(json["tasks"])
        .map((task) => Task.fromJson(task))
        .where(((task) => task.id != null))
      );
      return TaskLoadSuccess(
        lastSyncPull: nullableDateTimefromJson(lastSyncPullString),
        lastSyncPush: nullableDateTimefromJson(lastSyncPushString),
        tasks: tasks,
      );
    }
    catch(error) {
      print("fromJson error $error");
    }
  }

  @override
  Map<String, dynamic>? toJson(TaskState state) {
    print("toJson");
    try{
      if(state is TaskLoadSuccess){
        final tasks = jsonEncode(state.tasks.map((task) => task.toJson()).toList());
        return {
          "lastSyncPull": nullableDateTimeToJson(state.lastSyncPull),
          "lastSyncPush": nullableDateTimeToJson(state.lastSyncPush),
          "tasks": tasks,
        };
      }
    }
    catch(error) {
      print("toJson error $error");
    }
  }
}