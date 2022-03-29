import 'dart:async';

import 'package:bloc/bloc.dart';
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
  }) : super(CalendarState.initial) {

    tasksSubscription = taskBloc.stream.listen((state) {
      add(TasksUpdated(state.tasks));
    });

    on<CalendarSelectedMonthChanged>((event, emit){
      emit(state.copyWith(selectedMonth: event.selectedMonth));
    });

    on<CalendarSelectedDayChanged>((event, emit){
      emit(state.copyWith(
        selectedDay: event.selectedDay,
        items: groupByHour(
          tasks: taskBloc.state.tasks,
          selectedDay: event.selectedDay
        )
      ));
    });

    on<TasksUpdated>((event, emit){
      emit(state.copyWith(
        items: groupByHour(
          tasks: event.tasks,
          selectedDay: state.selectedDay
        )
      ));
    });
  }

  List<DynamicObject> groupByHour({
    required List<Task> tasks,
    required DateTime selectedDay
  }){
    tasks = tasks.where((task) => task.date.dateDifference(selectedDay) == 0).toList();
    tasks.sort((a, b) => a.date.compareTo(b.date));

    List<DynamicObject> items = [];

    if(tasks.isNotEmpty){
      final now = DateTime.now().ignoreTime;

      DateTime lastHour = now.copyWith(hour: tasks.first.date.hour);
      items.add(DynamicObject(object: lastHour));

      for (Task task in tasks){
        final hour = now.copyWith(hour: task.date.hour);

        if(lastHour.isAtSameMomentAs(hour)) {
          items.add(DynamicObject(object: task));
        }
        else{
          lastHour = hour;
          items.add(DynamicObject(object: lastHour));
          items.add(DynamicObject(object: task));
        }
      }
    }

    return items;
  }

  @override
  Future<void> close() async {
    await tasksSubscription.cancel();
    return super.close();
  }
}