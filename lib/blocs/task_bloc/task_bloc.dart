import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:task_manager/models/sync_item_error.dart';
import 'package:task_manager/models/sync_status.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/repositories/task_repository.dart';

part 'task_event.dart';
part 'task_state.dart';

part 'task_bloc.g.dart';

class TaskBloc extends HydratedBloc<TaskEvent, TaskState> {

  final TaskRepository taskRepository;
  TaskBloc({required this.taskRepository}) : super(TaskLoadSuccess.initial()){

    // TODO: Remove event
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
      final taskState = event.state;
      if(taskState is TaskLoadSuccess){
        print("SyncPushStatus: " + taskState.syncPushStatus.name);
        print("Tasks: ${taskState.tasks}");
        print("DeletedTasks: ${taskState.deletedTasks}");
        print("FailedTasks: ${taskState.failedTasks}");
      }
      emit(event.state);
    },
    transformer: restartable());
  }

  @override
  TaskState? fromJson(Map<String, dynamic> json) {
    try{
      print("taskBloc fromJson");
      return TaskLoadSuccess.fromJson(json);
    }
    catch(error) {
      print("taskBloc fromJson error: $error");
    }
  }

  @override
  Map<String, dynamic>? toJson(TaskState state) {
    try{
      print("taskBloc toJson");
      final taskState = state;
      if(taskState is TaskLoadSuccess) return taskState.toJson();
    }
    catch(error) {
      print("taskBloc toJson error: $error");
    }
  }
}