part of 'calendar_bloc.dart';

@immutable
abstract class CalendarEvent {}

class CalendarMonthUpdated extends CalendarEvent {
  final DateTime date;
  CalendarMonthUpdated(this.date);
}

class CalendarDateUpdated extends CalendarEvent {
  final DateTime date;
  CalendarDateUpdated(this.date);
}

class TasksUpdated extends CalendarEvent {
  final List<Task> tasks;
  TasksUpdated(this.tasks);
}