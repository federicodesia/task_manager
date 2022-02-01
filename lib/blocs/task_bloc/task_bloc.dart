import 'dart:convert';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_manager/blocs/sync_bloc/sync_bloc.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/repositories/task_repository.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends HydratedBloc<TaskEvent, TaskState> {

  final TaskRepository taskRepository;
  TaskBloc({required this.taskRepository}) : super(TaskLoadSuccess(tasks: [])){

    on<TaskLoaded>((event, emit){});

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
        emit(taskState.copyWith(tasks: taskState.tasks.map((task){
          return task.id == event.task.id ? event.task.copyWith(deletedAt: DateTime.now()) : task;
        }).toList()));
      }
    });

    /*on<TaskSyncPullRequested>((event, emit) async{
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
    transformer: restartable());*/
    
    on<TasksUpdated>((event, emit){
      final taskState = state;
      if(taskState is TaskLoadSuccess){
        emit(taskState.copyWith(tasks: event.tasks));
      }
    });

    on<TaskStateUpdated>((event, emit){
      print("Actualizando TaskState...");
      emit(event.state);
    },
    transformer: restartable());
  }

  @override
  TaskState? fromJson(Map<String, dynamic> json) {
    print("fromJson");
    try{
      /*final lastSyncPullString = json["lastSyncPull"];
      final lastSyncPushString = json["lastSyncPush"];*/

      final tasks = List<Task>.from(jsonDecode(json["tasks"])
        .map((task) => Task.fromJson(task))
        .where(((task) => task.id != null))
      );
      return TaskLoadSuccess(
        /*lastSyncPull: nullableDateTimefromJson(lastSyncPullString),
        lastSyncPush: nullableDateTimefromJson(lastSyncPushString),*/
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
          /*"lastSyncPull": nullableDateTimeToJson(state.lastSyncPull),
          "lastSyncPush": nullableDateTimeToJson(state.lastSyncPush),*/
          "tasks": tasks,
        };
      }
    }
    catch(error) {
      print("toJson error $error");
    }
  }
}