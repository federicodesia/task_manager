import 'dart:convert';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/cupertino.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_manager/helpers/date_time_helper.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/repositories/task_repository.dart';
import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends HydratedBloc<TaskEvent, TaskState> {

  final TaskRepository taskRepository;
  TaskBloc({required this.taskRepository}) : super(TaskLoadInProgress()){

    on<TaskLoaded>((event, emit) async{
      add(TaskSyncPullRequested());
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
        emit(taskState.copyWith(tasks: taskState.tasks.map((task){
          return task.id == event.task.id ? event.task.copyWith(deletedAt: DateTime.now()) : task;
        }).toList()));
        add(TaskSyncPushRequested());
      }
    });

    on<TaskSyncPullRequested>((event, emit) async{
      final eventId = Uuid().v4();
      print("$eventId | SyncPull requested");
      
      print("$eventId | Enviando peticion a la API...");
      final taskState = state;
      final responseTasks = await taskRepository.syncPull(
        lastSync: taskState is TaskLoadSuccess ? taskState.lastSyncPull : null
      );

      await Future.delayed(Duration(seconds: 2));
      print("$eventId | Respuesta de la API recibida...");

      if(responseTasks != null){
        print("$eventId | Remplazando nuevo estado con las tasks recibidas de la API...");

        final emitState = taskState is TaskLoadSuccess ? taskState : TaskLoadSuccess(); 

        emit(TaskLoadSuccess(
          lastSyncPull: DateTime.now(),
          tasks: emitState.tasks.map((t){
            final r = responseTasks.firstWhereOrNull((r) => r.id == t.id);
            responseTasks.remove(r);
            return r ?? t;
          }).toList()..addAll(responseTasks)
        ));
      }
    },
    transformer: restartable());

    on<TaskSyncPushRequested>((event, emit) async{
      final eventId = Uuid().v4();
      print("$eventId | SyncPush requested");
      

      final taskState = state;
      if(taskState is TaskLoadSuccess){

        final lastSyncPush = taskState.lastSyncPush;
        print("$eventId | Enviando peticion a la API...");
        final responseTasks = await taskRepository.syncPush(tasks: lastSyncPush != null
          ? taskState.tasks.where((t) => t.updatedAt.isAfter(lastSyncPush)).toList()
          : taskState.tasks
        );

        await Future.delayed(Duration(seconds: 2));
        print("$eventId | Respuesta de la API recibida...");

        if(responseTasks != null){
          print("$eventId | Remplazando nuevo estado con las tasks recibidas de la API...");
          emit(taskState.copyWith(
            lastSyncPush: DateTime.now(),
            tasks: taskState.tasks.map((t){
              final r = responseTasks.firstWhereOrNull((r) => r.id == t.id);
              responseTasks.remove(r);
              return r ?? t;
            }).toList()
          ));
        }
      }
    },
    transformer: restartable());
    
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