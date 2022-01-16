import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/helpers/date_time_helper.dart';
import 'package:task_manager/models/dynamic_object.dart';
import 'package:task_manager/models/task.dart';

part 'upcoming_event.dart';
part 'upcoming_state.dart';

class UpcomingBloc extends Bloc<UpcomingEvent, UpcomingState> {
  final TaskBloc taskBloc;
  late StreamSubscription todosSubscription;

  UpcomingBloc({
    required this.taskBloc
  }) : super(UpcomingLoadInProgress()) {
    todosSubscription = taskBloc.stream.listen((state) {
      if(state is TaskLoadSuccess) {
        add(TasksUpdated(state.tasks));
      }
    });

    on<UpcomingLoaded>((event, emit){
      TaskState taskBlocState = taskBloc.state;
      if(taskBlocState is TaskLoadSuccess){
        add(TasksUpdated(taskBlocState.tasks));
      }
    });

    on<TasksUpdated>((event, emit){
      TaskState taskBlocState = taskBloc.state;
      if(taskBlocState is TaskLoadSuccess){
        emit(UpcomingLoadSuccess(
          weekTasks: _getWeekTasks(taskBlocState.tasks),
          items: _getGroups(taskBlocState.tasks)
        ));
      }
    });
  }

  List<Task> _getWeekTasks(List<Task> tasks){
    DateTime now = DateTime.now();
    int weekday = now.weekday - 1;

    List<Task> weekTasks = tasks.where((task){
      int difference = dateDifference(task.date, now);
      return difference >= weekday * -1 && difference < 7 - weekday;
    }).toList();

    return weekTasks;
  }

  List<DynamicObject> _getGroups(List<Task> tasks){
    List<DynamicObject> items = [];

    DateTime now = DateTime.now();
    tasks = tasks.where((task) => dateDifference(task.date, now) >= 1).toList();
    tasks.sort((a, b) => a.date.compareTo(b.date));

    if(tasks.length > 0){

      int dateTimeCount = 1;
      DateTime lastDateTime = getDate(tasks.first.date);
      items.add(DynamicObject(object: lastDateTime));

      for(int i = 0; i < tasks.length; i++){
        Task task = tasks[i];
        if(dateDifference(task.date, lastDateTime) == 0) items.add(DynamicObject(object: task));
        else if(dateTimeCount == 3) break;
        else{
          lastDateTime = getDate(task.date);
          items.add(DynamicObject(object: lastDateTime));
          items.add(DynamicObject(object: task));
          dateTimeCount++;
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