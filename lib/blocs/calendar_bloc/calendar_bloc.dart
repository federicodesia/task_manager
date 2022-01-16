import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/helpers/date_time_helper.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/models/dynamic_object.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final TaskBloc taskBloc;
  late StreamSubscription tasksSubscription;

  CalendarBloc({
    required this.taskBloc,
  }) : super(CalendarLoadInProgress()) {
    tasksSubscription = taskBloc.stream.listen((state) {
      if(state is TaskLoadSuccess) {
        add(TasksUpdated(state.tasks));
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
          items: null
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
          items: _getGroupsByDate(taskBlocState.tasks, event.date)
        ));
      }
    });

    on<TasksUpdated>((event, emit){
      TaskState taskBlocState = taskBloc.state;
      if(state is CalendarLoadSuccess && taskBlocState is TaskLoadSuccess){
        emit((state as CalendarLoadSuccess).copyWith(
          items: _getGroupsByDate(event.tasks, (state as CalendarLoadSuccess).selectedDay)
        ));
      }
    });
  }

  List<DynamicObject> _getGroupsByDate(List<Task> tasks, DateTime date){
    List<Task> _tasks = tasks.where((task) => dateDifference(task.date, date) == 0).toList();
    _tasks.sort((a, b) => a.date.compareTo(b.date));

    List<DynamicObject> groups = [];
    DateTime now = DateTime.now();

    if(_tasks.length > 0){
      for(int i = _tasks.first.date.hour; i <= _tasks.last.date.hour; i++){
        groups.add(DynamicObject(
          object: DateTime(now.year, now.month, now.day, i)
        ));

        _tasks.where((task) => task.date.hour == i).forEach((task) {
          groups.add(DynamicObject(object: task));
        });
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
    return super.close();
  }
}