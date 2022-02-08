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
      return TaskLoadSuccess.fromJson(json);
    }
    catch(error) {}
  }

  @override
  Map<String, dynamic>? toJson(TaskState state) {
    try{
      final taskState = state;
      if(taskState is TaskLoadSuccess) return taskState.toJson();
    }
    catch(error) {}
  }
}