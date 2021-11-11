part of 'calendar_bloc.dart';

@immutable
abstract class CalendarState {}

class CalendarLoadInProgress extends CalendarState {}

class CalendarLoadSuccess extends CalendarState {
  final List<Task> tasks;
  final DateTime date;
  
  CalendarLoadSuccess({
    required this.tasks,
    required this.date
  });
}

class CalendarLoadFailure extends CalendarState {}