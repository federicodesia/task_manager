import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:task_manager/blocs/category_bloc/category_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/helpers/date_time_helper.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/models/dynamic_object.dart';

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
  }) : super(CalendarState.initial) {

    on<UpdateLoadingRequested>((event, emit) async {
      if(state.isLoading){
        if(!taskBloc.state.isLoading && !categoryBloc.state.isLoading){
          emit(state.copyWith(isLoading: false));
          await categoriesSubscription.cancel();
        }
      }
      else{
        await categoriesSubscription.cancel();
      }
    });
    add(UpdateLoadingRequested());

    tasksSubscription = taskBloc.stream.listen((state) {
      add(UpdateLoadingRequested());
      add(TasksUpdated(state.tasks));
    });

    categoriesSubscription = categoryBloc.stream.listen((state) {
      add(UpdateLoadingRequested());
    });

    on<CalendarSelectedMonthChanged>((event, emit){
      final selectedMonth = event.selectedMonth;
      final currentIndex = state.selectedDay.day;

      DateTime selectedDay;
      if(currentIndex > selectedMonth.daysInMonth){
        selectedDay = selectedMonth.lastDayOfMonth;
      }
      else{
        selectedDay = selectedMonth.copyWith(day: currentIndex);
      }

      emit(state.copyWith(
        selectedMonth: selectedMonth,
        selectedDay: selectedDay,
        items: groupByHour(
          tasks: taskBloc.state.tasks,
          selectedDate: selectedDay
        )
      ));
    });

    on<CalendarSelectedDayChanged>((event, emit){
      emit(state.copyWith(
        selectedDay: event.selectedDay,
        items: groupByHour(
          tasks: taskBloc.state.tasks,
          selectedDate: event.selectedDay
        )
      ));
    });

    on<TasksUpdated>((event, emit){
      emit(state.copyWith(
        items: groupByHour(
          tasks: event.tasks,
          selectedDate: state.selectedDay
        )
      ));
    });
  }

  List<DynamicObject> groupByHour({
    required List<Task> tasks,
    required DateTime selectedDate
  }){
    tasks = tasks.where((task) => task.date.differenceInDays(selectedDate) == 0).toList();
    tasks.sort((a, b) => a.date.compareTo(b.date));

    List<DynamicObject> items = [];

    if(tasks.isNotEmpty){
      final now = DateTime.now().ignoreTime;

      int hour = tasks.first.date.hour;
      for (Task task in tasks){
        while(hour <= task.date.hour){
          items.add(DynamicObject(object: now.copyWith(hour: hour)));
          hour++;
        }
        items.add(DynamicObject(object: task));
      }
    }

    return items;
  }

  @override
  Future<void> close() async {
    await tasksSubscription.cancel();
    await categoriesSubscription.cancel();
    return super.close();
  }
}