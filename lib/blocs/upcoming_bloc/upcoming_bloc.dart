import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/helpers/date_time_helper.dart';
import 'package:task_manager/models/dynamic_object.dart';
import 'package:task_manager/models/task.dart';
import 'package:tuple/tuple.dart';

part 'upcoming_event.dart';
part 'upcoming_state.dart';

class UpcomingBloc extends Bloc<UpcomingEvent, UpcomingState> {
  final TaskBloc taskBloc;
  late StreamSubscription todosSubscription;

  UpcomingBloc({
    required this.taskBloc
  }) : super(UpcomingLoadInProgress()) {
    
    todosSubscription = taskBloc.stream.listen((state) {
      add(TasksUpdated(state.tasks));
    });

    on<UpcomingLoaded>((event, emit){
      add(TasksUpdated( taskBloc.state.tasks));
    });

    on<TasksUpdated>((event, emit){
      final tasks = taskBloc.state.tasks;
      final data = weekData(tasks);

      emit(UpcomingLoadSuccess(
        weekCompletedTasksCount: data.item1,
        weekRemainingTasksCount: data.item2,
        weekTasks: data.item3,
        weekCompletedTasks: data.item4,
        items: groupByDate(tasks)
      ));
    });
  }

  Tuple4<
    int,
    int,
    Map<DateTime, int>,
    Map<DateTime, int>
  > weekData(List<Task> tasks){

    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1)).ignoreTime;
    
    int weekCompletedTasksCount = 0;
    int weekRemainingTasksCount = 0;
    Map<DateTime, int> weekTasks = {};
    Map<DateTime, int> completedWeekTasks = {};

    for(int i = 0; i < DateTime.daysPerWeek; i++){
      final weekday = startOfWeek.add(Duration(days: i)).ignoreTime;
      final weekdayTasks = tasks.where((task) => task.date.dateDifference(weekday) == 0);
      final weekdayTasksCount = weekdayTasks.length;

      final weekdayCompletedTasks = weekdayTasks.where((task) => task.isCompleted);
      final weekdayCompletedTasksCount = weekdayCompletedTasks.length;

      weekCompletedTasksCount += weekdayCompletedTasksCount;
      weekRemainingTasksCount += weekdayTasksCount - weekdayCompletedTasksCount;

      weekTasks[weekday] = weekdayTasksCount;
      completedWeekTasks[weekday] = weekdayCompletedTasksCount;
    }

    return Tuple4(
      weekCompletedTasksCount,
      weekRemainingTasksCount,
      weekTasks.values.any((count) => count > 0) ? weekTasks : {},
      completedWeekTasks
    );
  }

  List<DynamicObject> groupByDate(List<Task> tasks){
    List<DynamicObject> items = [];

    final now = DateTime.now();
    tasks = tasks.where((task) => task.date.dateDifference(now) >= 1).toList();
    tasks.sort((a, b) => a.date.compareTo(b.date));

    if(tasks.isNotEmpty){

      int dateTimeCount = 1;
      DateTime lastDateTime = tasks.first.date.ignoreTime;
      items.add(DynamicObject(object: lastDateTime));

      for(Task task in tasks){

        if(task.date.dateDifference(lastDateTime) == 0) {
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