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
  }

  @override
  Stream<CalendarState> mapEventToState(CalendarEvent event) async* {

    if(taskBloc.state is TaskLoadSuccess){
      if(event is CalendarSelectedDateUpdated){
        yield CalendarLoadSuccess(
          date: event.date,
          tasks: _filterTasksByDate((taskBloc.state as TaskLoadSuccess).tasks, event.date)
        );
      }

      else if(taskBloc.state is TaskLoadSuccess){
        DateTime date = (state is CalendarLoadSuccess) ? (state as CalendarLoadSuccess).date : DateTime.now();
        yield CalendarLoadSuccess(
          date: date,
          tasks: _filterTasksByDate((taskBloc.state as TaskLoadSuccess).tasks, date)
        );
      }
    }
  }

  List<Task> _filterTasksByDate(List<Task> tasks, DateTime date){
    return tasks.where((task) => dateDifference(task.dateTime, date) == 0).toList();
  }

  @override
  Future<void> close() {
    todosSubscription.cancel();
    return super.close();
  }
}