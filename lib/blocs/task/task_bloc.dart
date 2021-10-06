import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/repositories/task_repository.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {

  final TaskRepository taskRepository;
  TaskBloc({this.taskRepository}) : super(TaskLoadInProgress());

  @override
  Stream<TaskState> mapEventToState(TaskEvent event) async* {
    
    if(event is TaskLoaded){
      try {
        final tasks = await taskRepository.fetchTasks();
        yield TaskLoadSuccess(tasks);
      } catch (_) {
        yield TaskLoadFailure();
      }
    }
    else if(event is TaskAdded){
      final updatedTasks = await taskRepository.saveTask(event.task);
      yield TaskLoadSuccess(updatedTasks);
    }
    else if(event is TaskUpdated){
      final updatedTasks = await taskRepository.updateTask(event.oldTask, event.taskUpdated);
      yield TaskLoadSuccess(updatedTasks);
    }
    else if(event is TaskDeleted){
      final updatedTasks = await taskRepository.deleteTask(event.task);
      yield TaskLoadSuccess(updatedTasks);
    }
    else if(event is TaskCompleted){
      final updatedTasks = await taskRepository.completedTask(event.task, event.value);
      yield TaskLoadSuccess(updatedTasks);
    }
  }
}