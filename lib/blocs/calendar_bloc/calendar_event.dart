part of 'calendar_bloc.dart';

abstract class CalendarEvent {}

class CalendarSelectedMonthChanged extends CalendarEvent {
  final DateTime selectedMonth;
  CalendarSelectedMonthChanged(this.selectedMonth);
}

class CalendarSelectedDayChanged extends CalendarEvent {
  final DateTime selectedDay;
  CalendarSelectedDayChanged(this.selectedDay);
}

class UpdateLoadingRequested extends CalendarEvent {}

class TasksUpdated extends CalendarEvent {
  final List<Task> tasks;
  TasksUpdated(this.tasks);
}