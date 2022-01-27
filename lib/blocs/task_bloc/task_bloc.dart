import 'dart:convert';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/repositories/task_repository.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends HydratedBloc<TaskEvent, TaskState> {

  final TaskRepository taskRepository;
  TaskBloc({required this.taskRepository}) : super(TaskLoadInProgress()){

    on<TaskLoaded>((event, emit) async{
      final tasks = await taskRepository.getTasks();
      if(tasks != null) emit(TaskLoadSuccess(tasks));
      else emit(TaskLoadFailure());
    });

    on<TaskAdded>((event, emit) async{
      if(state is TaskLoadSuccess){
        emit(TaskLoadSuccess((state as TaskLoadSuccess).tasks..add(event.task)));
      }
    });

    on<TaskUpdated>((event, emit){
      if(state is TaskLoadSuccess){
        emit(TaskLoadSuccess((state as TaskLoadSuccess).tasks.map((task){
          return task.id == event.task.id ? event.task : task;
        }).toList()));
      }
    });

    on<TaskDeleted>((event, emit){
      if(state is TaskLoadSuccess){
        emit(TaskLoadSuccess((state as TaskLoadSuccess).tasks
          .where((task) => task.id != event.task.id).toList()));
      }
    });

    on<TaskCompleted>((event, emit){
      if(state is TaskLoadSuccess){
        emit(TaskLoadSuccess((state as TaskLoadSuccess).tasks.map((task){
          return task.id == event.task.id ? task.copyWith(isCompleted: event.value) : task;
        }).toList()));
      }
    });

    on<TasksUpdated>((event, emit){
      if(state is TaskLoadSuccess){
        emit(TaskLoadSuccess(event.tasks));
      }
    });
  }

  @override
  TaskState? fromJson(Map<String, dynamic> json) {
    try{
      final tasks = List<Task>.from(jsonDecode(json["tasks"])
        .map((task) => Task.fromJson(task))
        .where(((task) => task.id != null))
      );
      return TaskLoadSuccess(tasks);
    }
    catch(_) {}
  }

  @override
  Map<String, dynamic>? toJson(TaskState state) {
    try{
      if(state is TaskLoadSuccess){
        final tasks = jsonEncode(state.tasks.map((task) => task.toJson()).toList());
        return {
          "tasks": tasks
        };
      }
    }
    catch(_) {}
  }
}