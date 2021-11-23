import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/helpers/date_time_helper.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/models/tasks_group_date.dart';

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
        add(TasksUpdated((taskBloc.state as TaskLoadSuccess).tasks));
      }
    });

    on<UpcomingLoaded>((event, emit) => add(TasksUpdated((taskBloc.state as TaskLoadSuccess).tasks)));

    on<TasksUpdated>((event, emit) => emit(
      UpcomingLoadSuccess(
        weekTasks: _getWeekTasks((taskBloc.state as TaskLoadSuccess).tasks),
        groups: _getGroups((taskBloc.state as TaskLoadSuccess).tasks)
      )
    ));
  }

  List<Task> _getWeekTasks(List<Task> tasks){
    DateTime now = DateTime.now();
    int weekday = now.weekday - 1;

    List<Task> weekTasks = tasks.where((task){
      int difference = dateDifference(task.dateTime, now);
      return difference >= weekday * -1 && difference < 7 - weekday;
    }).toList();

    return weekTasks;
  }

  List<TaskGroupDate> _getGroups(List<Task> tasks){
    List<TaskGroupDate> groups = [];

    DateTime now = DateTime.now();
    tasks = tasks.where((task) => dateDifference(task.dateTime, now) >= 1).toList();
    tasks.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    if(tasks.length > 0){
      groups.add(
        TaskGroupDate(
          dateTime: getDate(tasks.first.dateTime),
          tasks: []
        )
      );

      for(int i = 0; i < tasks.length; i++){
        Task task = tasks[i];
        TaskGroupDate lastGroup = groups.last;

        if(dateDifference(task.dateTime, lastGroup.dateTime) == 0) lastGroup.tasks.add(task);
        else if(groups.length - 1 == 3) break; // Max 3 groups
        else{
          groups.add(
            TaskGroupDate(
              dateTime: getDate(task.dateTime),
              tasks: [task]
            )
          );
        }
      }
    }
    return groups;
  }

  @override
  Future<void> close() {
    todosSubscription.cancel();
    return super.close();
  }
}