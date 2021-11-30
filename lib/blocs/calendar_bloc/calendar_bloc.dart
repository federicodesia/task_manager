import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_manager/blocs/category_bloc/category_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/helpers/date_time_helper.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/models/tasks_group_hour.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final TaskBloc taskBloc;
  final CategoryBloc categoryBloc;
  late StreamSubscription tasksSubscription;
  late StreamSubscription categoriesSubscription;

  CalendarBloc({
    required this.taskBloc,
    required this.categoryBloc
  }) : super(CalendarLoadInProgress()) {
    tasksSubscription = taskBloc.stream.listen((state) {
      if(state is TaskLoadSuccess) {
        add(TasksUpdated(state.tasks));
      }
    });

    categoriesSubscription = categoryBloc.stream.listen((state) {
      TaskState taskBlocState = taskBloc.state;
      if(taskBlocState is TaskLoadSuccess) {
        add(TasksUpdated(taskBlocState.tasks));
      }
    });

    on<CalendarLoaded>((event, emit){
      List<DateTime> months = [];
      DateTime iterator;
      DateTime limit;

      iterator = DateTime(event.startMonth.year, event.startMonth.month);
      limit = event.endMonth;
      
      while (iterator.isBefore(limit))
      {
        months.add(DateTime(iterator.year, iterator.month));
        iterator = DateTime(iterator.year, iterator.month + 1);
      }

      emit(
        CalendarLoadSuccess(
          months: months,
          selectedMonth: event.selectedDate,
          days: _getDaysOfMonth(event.selectedDate),
          selectedDay: event.selectedDate,
          groups: []
        )
      );
    });

    on<CalendarMonthUpdated>((event, emit){
      if(state is CalendarLoadSuccess){
        emit((state as CalendarLoadSuccess).copyWith(
          selectedMonth: event.month,
          days: _getDaysOfMonth(event.month)
        ));
      }
    });

    on<CalendarDateUpdated>((event, emit){
      TaskState taskBlocState = taskBloc.state;
      if(state is CalendarLoadSuccess && taskBlocState is TaskLoadSuccess){
        emit((state as CalendarLoadSuccess).copyWith(
          selectedDay: event.date,
          groups: _getGroupsByDate(taskBlocState.tasks, event.date)
        ));
      }
    });

    on<TasksUpdated>((event, emit){
      TaskState taskBlocState = taskBloc.state;
      if(state is CalendarLoadSuccess && taskBlocState is TaskLoadSuccess){
        emit((state as CalendarLoadSuccess).copyWith(
          groups: _getGroupsByDate(taskBlocState.tasks, (state as CalendarLoadSuccess).selectedDay)
        ));
      }
    });
  }

  List<TaskGroupHour> _getGroupsByDate(List<Task> tasks, DateTime date){
    List<Task> _tasks = tasks.where((task) => dateDifference(task.dateTime, date) == 0).toList();
    _tasks.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    List<TaskGroupHour> groups = [];

    if(_tasks.length > 0){
      for(int i = _tasks.first.dateTime.hour; i <= _tasks.last.dateTime.hour; i++){
        groups.add(
          TaskGroupHour(
            hour: copyDateTimeWith(
              date,
              hour: i
            ),
            tasks: _tasks.where((task) => task.dateTime.hour == i).toList()
          )
        );
      }
    }
    return groups;
  }

  List<DateTime> _getDaysOfMonth(DateTime date){
    List<DateTime> days = [];
    for(int i = 0; i < daysInMonth(date); i++){
      days.add(DateTime(date.year, date.month, i + 1));
    }
    return days;
  }

  @override
  Future<void> close() {
    tasksSubscription.cancel();
    categoriesSubscription.cancel();
    return super.close();
  }
}