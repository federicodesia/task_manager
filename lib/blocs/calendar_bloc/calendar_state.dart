part of 'calendar_bloc.dart';

@immutable
abstract class CalendarState {}

class CalendarLoadInProgress extends CalendarState {}

class CalendarLoadSuccess extends CalendarState {
  final DateTime selectedMonth;
  final List<DateTime> months;
  final DateTime selectedDay;
  final List<DateTime> days;
  final List<Task> tasks;
  
  CalendarLoadSuccess({
    required this.selectedMonth,
    required this.months,
    required this.selectedDay,
    required this.days,
    required this.tasks
  });

  CalendarLoadSuccess copyWith({
    DateTime? selectedMonth,
    List<DateTime>? months,
    DateTime? selectedDay,
    List<DateTime>? days,
    List<Task>? tasks
  }){
    return CalendarLoadSuccess(
      selectedMonth: selectedMonth ?? this.selectedMonth,
      months: months ?? this.months,
      selectedDay: selectedDay ?? this.selectedDay,
      days: days ?? this.days,
      tasks: tasks ?? this.tasks
    );
  }
}

class CalendarLoadFailure extends CalendarState {}