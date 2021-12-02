import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/repositories/task_repository.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {

  final TaskRepository taskRepository;
  TaskBloc({required this.taskRepository}) : super(TaskLoadInProgress()){

    on<TaskLoaded>((event, emit) async{
      try{
        final tasks = await taskRepository.fetchTasks();
        emit(TaskLoadSuccess(tasks));
      }
      catch(_){
        emit(TaskLoadFailure());
      }
    });

    on<TaskAdded>((event, emit){
      if(state is TaskLoadSuccess){
        emit(TaskLoadSuccess((state as TaskLoadSuccess).tasks..add(event.task)));
      }
    });

    on<TaskUpdated>((event, emit){
      if(state is TaskLoadSuccess){
        emit(TaskLoadSuccess((state as TaskLoadSuccess).tasks.map((task){
          return task.uuid == event.task.uuid ? event.task : task;
        }).toList()));
      }
    });

    on<TaskDeleted>((event, emit){
      if(state is TaskLoadSuccess){
        emit(TaskLoadSuccess((state as TaskLoadSuccess).tasks
          .where((task) => task.uuid != event.task.uuid).toList()));
      }
    });

    on<TaskCompleted>((event, emit){
      if(state is TaskLoadSuccess){
        emit(TaskLoadSuccess((state as TaskLoadSuccess).tasks.map((task){
          return task.uuid == event.task.uuid ? task.copyWith(completed: event.value) : task;
        }).toList()));
      }
    });

    on<TasksUpdated>((event, emit){
      if(state is TaskLoadSuccess){
        emit(TaskLoadSuccess(event.tasks));
      }
    });
  }
}