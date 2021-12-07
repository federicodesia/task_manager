import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/helpers/date_time_helper.dart';
import 'package:task_manager/models/category.dart';
import 'package:task_manager/models/dynamic_object.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/models/task_filter.dart';

part 'category_screen_event.dart';
part 'category_screen_state.dart';

class CategoryScreenBloc extends Bloc<CategoryScreenEvent, CategoryScreenState> {
  final TaskBloc taskBloc;
  final String? categoryUuid;
  late StreamSubscription todosSubscription;

  CategoryScreenBloc({
    required this.taskBloc,
    required this.categoryUuid
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
          activeFilter: TaskFilter.All,
          items: _getGroups(TaskFilter.All, taskBlocState.tasks)
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

    tasks = tasks.where((task) => task.categoryUuid == categoryUuid).toList();
    if(filter == TaskFilter.Completed) tasks = tasks.where((task) => task.completed).toList();
    else if(filter == TaskFilter.Uncompleted) tasks = tasks.where((task) => !task.completed).toList();

    if(tasks.isNotEmpty){
      tasks.sort((a, b) => a.dateTime.compareTo(b.dateTime));

      DateTime lastDateTime = getDate(tasks.first.dateTime);
      items.add(DynamicObject(object: lastDateTime));

      for(int i = 0; i < tasks.length; i++){
        Task task = tasks[i];
        if(dateDifference(task.dateTime, lastDateTime) == 0) items.add(DynamicObject(object: task));
        else{
          lastDateTime = getDate(task.dateTime);
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