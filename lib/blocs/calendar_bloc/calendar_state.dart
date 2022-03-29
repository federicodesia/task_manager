part of 'calendar_bloc.dart';

class CalendarState {

  final bool isLoading;
  final DateTime selectedMonth;
  final List<DateTime> months;
  final DateTime selectedDay;
  final List<DateTime> days;
  final List<DynamicObject> items;
  
  CalendarState({
    required this.isLoading,
    required this.selectedMonth,
    required this.months,
    required this.selectedDay,
    required this.days,
    required this.items
  });

  static CalendarState get initial {
    final now = DateTime.now().ignoreTime;
    final start = DateTime(now.year - 1, now.month);
    final end = DateTime(now.year + 1, now.month);

    return CalendarState(
      isLoading: true,
      selectedMonth: now,
      months: start.monthsBefore(end),
      selectedDay: now,
      days: now.listDaysInMonth,
      items: []
    );
  }

  CalendarState copyWith({
    bool? isLoading,
    DateTime? selectedMonth,
    DateTime? selectedDay,
    List<DynamicObject>? items
  }){
    return CalendarState(
      isLoading: isLoading ?? this.isLoading,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      months: months,
      selectedDay: selectedDay ?? this.selectedDay,
      days: selectedDay != null ? selectedDay.listDaysInMonth : days,
      items: items ?? this.items
    );
  }
}