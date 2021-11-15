part of 'calendar_bloc.dart';

@immutable
abstract class CalendarEvent {}

class CalendarLoaded extends CalendarEvent {
  final DateTime startMonth;
  final DateTime endMonth;
  final DateTime selectedDate;

  CalendarLoaded({
    required this.startMonth,
    required this.endMonth,
    required this.selectedDate
  });
}

class CalendarMonthUpdated extends CalendarEvent {
  final DateTime month;
  CalendarMonthUpdated(this.month);
}

class CalendarDateUpdated extends CalendarEvent {
  final DateTime date;
  CalendarDateUpdated(this.date);
}

class TasksUpdated extends CalendarEvent {
  final List<Task> tasks;
  TasksUpdated(this.tasks);
}