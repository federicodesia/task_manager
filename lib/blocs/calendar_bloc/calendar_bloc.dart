import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/helpers/date_time_helper.dart';
import 'package:task_manager/models/task.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final TaskBloc taskBloc;
  late StreamSubscription todosSubscription;

  CalendarBloc({
    required this.taskBloc
  }) : super(CalendarLoadInProgress()) {
    todosSubscription = taskBloc.stream.listen((state) {
      if(state is TaskLoadSuccess) {
        add(TasksUpdated((taskBloc.state as TaskLoadSuccess).tasks));
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
          tasks: []
        )
      );
    });

    on<CalendarMonthUpdated>((event, emit) => emit(
      (state as CalendarLoadSuccess).copyWith(
        selectedMonth: event.month,
        days: _getDaysOfMonth(event.month)
      )
    ));

    on<CalendarDateUpdated>((event, emit) => emit(
      (state as CalendarLoadSuccess).copyWith(
        selectedDay: event.date,
        tasks: _filterTasksByDate((taskBloc.state as TaskLoadSuccess).tasks, event.date)
      )
    ));

    on<TasksUpdated>((event, emit) => emit(
      (state as CalendarLoadSuccess).copyWith(
        tasks: _filterTasksByDate((taskBloc.state as TaskLoadSuccess).tasks, (state as CalendarLoadSuccess).selectedDay)
      )
    ));
  }

  List<Task> _filterTasksByDate(List<Task> tasks, DateTime date){
    return tasks.where((task) => dateDifference(task.dateTime, date) == 0).toList();
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
    todosSubscription.cancel();
    return super.close();
  }
}