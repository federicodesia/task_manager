import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/blocs/transformers.dart';
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
  }) : super(CategoryScreenState.initial){

    todosSubscription = taskBloc.stream.listen((state) => add(UpdateItemsRequested()));
    
    on<CategoryScreenLoaded>((event, emit){
      add(UpdateItemsRequested());
    });

    on<SearchTextChanged>((event, emit){
      add(UpdateItemsRequested(searchText: event.searchText));
    },
    transformer: debounceTransformer(const Duration(milliseconds: 500)));

    on<FilterUpdated>((event, emit){
      add(UpdateItemsRequested(taskFilter: event.taskFilter));
    });

    on<UpdateItemsRequested>((event, emit){
      emit(state.copyWith(
        searchText: event.searchText,
        activeFilter: event.taskFilter,
        items: _filter(
          searchText: event.searchText ?? state.searchText,
          taskFilter: event.taskFilter ?? state.activeFilter,
          tasks: taskBloc.state.tasks
        )
      ));
    });
  }

  List<DynamicObject> _filter({
    required String searchText,
    required TaskFilter taskFilter,
    required List<Task> tasks
  }){
    List<DynamicObject> items = [];

    tasks = tasks.where((task) => task.categoryId == categoryId).toList();

    if(taskFilter != TaskFilter.all){
      final isCompletedFilter = taskFilter == TaskFilter.completed;
      tasks = tasks.where((task) => task.isCompleted == isCompletedFilter).toList();
    }

    searchText = searchText.trim().toUpperCase();
    if(searchText.isNotEmpty){

      tasks = tasks.where((task){
        if(task.title.toUpperCase().contains(searchText)) return true;
        if(task.description.toUpperCase().contains(searchText)) return true;
        return false;
      }).toList();
    }

    if(tasks.isNotEmpty){
      tasks.sort((a, b) => a.date.compareTo(b.date));

      DateTime lastDateTime = tasks.first.date.ignoreTime;
      items.add(DynamicObject(object: lastDateTime));

      for(int i = 0; i < tasks.length; i++){
        Task task = tasks[i];
        if(task.date.differenceInDays(lastDateTime) == 0) {
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
  Future<void> close() async {
    await todosSubscription.cancel();
    return super.close();
  }
}