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
        final weekData = _getWeekData(taskBlocState.tasks);

        emit(UpcomingLoadSuccess(
          weekCompletedTasksCount: weekData.item1,
          weekRemainingTasksCount: weekData.item2,
          weekTasks: weekData.item3,
          weekCompletedTasks: weekData.item4,
          items: _getGroups(taskBlocState.tasks)
        ));
      }
    });
  }

  Tuple4<
    int,
    int,
    Map<DateTime, int>,
    Map<DateTime, int>
  > _getWeekData(List<Task> tasks){

    final now = DateTime.now();
    final startOfWeek = getDate(now.subtract(Duration(days: now.weekday - 1)));
    
    int weekCompletedTasksCount = 0;
    int weekRemainingTasksCount = 0;
    Map<DateTime, int> weekTasks = {};
    Map<DateTime, int> completedWeekTasks = {};

    for(int i = 0; i < DateTime.daysPerWeek; i++){
      final weekday = getDate(startOfWeek.add(Duration(days: i)));
      final weekdayTasks = tasks.where((task) => dateDifference(task.date, weekday) == 0);
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