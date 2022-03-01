import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/helpers/date_time_helper.dart';
import 'package:task_manager/models/dynamic_object.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/models/task_filter.dart';

part 'category_screen_event.dart';
part 'category_screen_state.dart';

class CategoryScreenBloc extends Bloc<CategoryScreenEvent, CategoryScreenState> {
  final TaskBloc taskBloc;
  final String? categoryId;
  late StreamSubscription todosSubscription;

  CategoryScreenBloc({
    required this.taskBloc,
    required this.categoryId
  }) : super(CategoryScreenLoadInProgress()){

    todosSubscription = taskBloc.stream.listen((state) {
      if(state is TaskLoadSuccess) {
        add(TasksUpdated(state.tasks));
      }
    });

    on<CategoryScreenLoaded>((event, emit){
      TaskState taskBlocState = taskBloc.state;
      if(taskBlocState is TaskLoadSuccess){
        emit(CategoryScreenLoadSuccess(
          activeFilter: TaskFilter.all,
          items: _getGroups(TaskFilter.all, taskBlocState.tasks)
        ));
      }
    });

    on<CategoryScreenFilterUpdated>((event, emit){
      TaskState taskBlocState = taskBloc.state;
      if(taskBlocState is TaskLoadSuccess){
        emit(CategoryScreenLoadSuccess(
          activeFilter: event.filter,
          items: _getGroups(event.filter, taskBlocState.tasks)
        ));
      }
    });

    on<TasksUpdated>((event, emit){
      TaskState taskBlocState = taskBloc.state;
      if(state is CategoryScreenLoadSuccess && taskBlocState is TaskLoadSuccess){
        emit(CategoryScreenLoadSuccess(
          activeFilter: (state as CategoryScreenLoadSuccess).activeFilter,
          items: _getGroups((state as CategoryScreenLoadSuccess).activeFilter, event.tasks)
        ));
      }
    });
  }

  List<DynamicObject> _getGroups(TaskFilter filter, List<Task> tasks){
    List<DynamicObject> items = [];

    tasks = tasks.where((task) => task.categoryId == categoryId).toList();
    if(filter == TaskFilter.completed) {
      tasks = tasks.where((task) => task.isCompleted).toList();
    } else if(filter == TaskFilter.remaining) {
      tasks = tasks.where((task) => !task.isCompleted).toList();
    }

    if(tasks.isNotEmpty){
      tasks.sort((a, b) => a.date.compareTo(b.date));

      DateTime lastDateTime = tasks.first.date.ignoreTime;
      items.add(DynamicObject(object: lastDateTime));

      for(int i = 0; i < tasks.length; i++){
        Task task = tasks[i];
        if(task.date.dateDifference(lastDateTime) == 0) {
          items.add(DynamicObject(object: task));
        } else{
          lastDateTime = task.date.ignoreTime;
          items.add(DynamicObject(object: lastDateTime));
          items.add(DynamicObject(object: task));
        }
      }
    }
    return items;
  }

  @override
  Future<void> close() {
    todosSubscription.cancel();
    return super.close();
  }
}