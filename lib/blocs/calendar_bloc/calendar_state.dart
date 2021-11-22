part of 'calendar_bloc.dart';

@immutable
abstract class CalendarState {}

class CalendarLoadInProgress extends CalendarState {}

class CalendarLoadSuccess extends CalendarState {
  final DateTime selectedMonth;
  final List<DateTime> months;
  final DateTime selectedDay;
  final List<DateTime> days;
  final List<TaskGroupHour> groups;
  
  CalendarLoadSuccess({
    required this.selectedMonth,
    required this.months,
    required this.selectedDay,
    required this.days,
    required this.groups
  });

  CalendarLoadSuccess copyWith({
    DateTime? selectedMonth,
    List<DateTime>? months,
    DateTime? selectedDay,
    List<DateTime>? days,
    List<TaskGroupHour>? groups
  }){
    return CalendarLoadSuccess(
      selectedMonth: selectedMonth ?? this.selectedMonth,
      months: months ?? this.months,
      selectedDay: selectedDay ?? this.selectedDay,
      days: days ?? this.days,
      groups: groups ?? this.groups
    );
  }
}

class CalendarLoadFailure extends CalendarState {}