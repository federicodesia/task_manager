import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/helpers/date_time_helper.dart';
import 'package:task_manager/helpers/map_helper.dart';
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
      if(!state.isLoading) add(TasksUpdated(state.tasks));
    });
    
    on<UpcomingLoaded>((event, emit){
      final taskBlocState = taskBloc.state;
      if(!taskBlocState.isLoading) add(TasksUpdated(taskBlocState.tasks));
    });
    add(UpcomingLoaded());

    on<TasksUpdated>((event, emit){
      final tasks = taskBloc.state.tasks;

      final now = DateTime.now();
      final startOfWeek = now.startOfWeek;
      final endOfWeek = now.endOfWeek;

      final weekdays = startOfWeek.daysBefore(endOfWeek);
      Map<DateTime, int> weekTasks = { for (DateTime day in weekdays) day : 0 };
      Map<DateTime, int> weekCompletedTasks = { for (DateTime day in weekdays) day : 0 };

      int weekTasksCount = 0;
      int weekCompletedTasksCount = 0;

      for(Task task in tasks){
        final taskDate = task.date.ignoreTime;
        if(taskDate.isBetween(startOfWeek, endOfWeek)){

          weekTasks.increment(taskDate);
          weekTasksCount++;

          if(task.isCompleted){
            weekCompletedTasks.increment(taskDate);
            weekCompletedTasksCount++;
          }
        }
      }
      
      final weekRemainingTasksCount = weekTasksCount - weekCompletedTasksCount;

      emit(UpcomingLoadSuccess(
        
        weekTasks: weekTasks,
        weekCompletedTasks: weekCompletedTasks,
        weekCompletedTasksCount: weekCompletedTasksCount,
        weekRemainingTasksCount: weekRemainingTasksCount,
        items: groupByDate(tasks)
      ));
    });
  }

  List<DynamicObject> groupByDate(List<Task> tasks){
    List<DynamicObject> items = [];

    final now = DateTime.now().ignoreTime;
    tasks = tasks.where((task) => task.date.differenceInDays(now) >= 1).toList();
    tasks.sort((a, b) => a.date.compareTo(b.date));

    if(tasks.isNotEmpty){

      int dateTimeCount = 1;
      DateTime lastDateTime = tasks.first.date.ignoreTime;
      items.add(DynamicObject(object: lastDateTime));

      for(Task task in tasks){

        if(task.date.differenceInDays(lastDateTime) == 0) {
          items.add(DynamicObject(object: task));
        }
        else if(dateTimeCount == 3) {
          break;
        } else{
          lastDateTime = task.date.ignoreTime;
          items.add(DynamicObject(object: lastDateTime));
          items.add(DynamicObject(object: task));
          dateTimeCount++;
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