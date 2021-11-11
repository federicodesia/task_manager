part of 'calendar_bloc.dart';

@immutable
abstract class CalendarEvent {}

class CalendarSelectedDateUpdated extends CalendarEvent {
  final DateTime date;
  CalendarSelectedDateUpdated(this.date);
}

class TasksUpdated extends CalendarEvent {
  final List<Task> tasks;
  TasksUpdated(this.tasks);
}