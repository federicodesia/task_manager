import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/helpers/string_helper.dart';
import 'package:task_manager/l10n/l10n.dart';

extension DateTimeExtension on DateTime {

  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond
  }){
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }

  DateTime get ignoreTime => DateTime(year, month, day);

  int differenceInDays(DateTime other) => ignoreTime.difference(other.ignoreTime).inDays;

  bool isAfterOrEqualTo(DateTime other) {
    return isAfter(other) || isAtSameMomentAs(other);
  }

  bool isBeforeOrEqualTo(DateTime other) {
    return isBefore(other) || isAtSameMomentAs(other);
  }

  DateTime get startOfWeek => subtract(Duration(days: weekday - 1)).ignoreTime;
  DateTime get endOfWeek => add(Duration(days: DateTime.daysPerWeek - weekday)).ignoreTime;
  bool isBetween(DateTime from, DateTime to) => isAfterOrEqualTo(from) && isBeforeOrEqualTo(to);
  
  int get daysInMonth{
    DateTime thisMonth = DateTime(year, month, 0);
    DateTime nextMonth = DateTime(year, month + 1, 0);
    return nextMonth.differenceInDays(thisMonth);
  }

  DateTime get lastDayOfMonth => DateTime(year, month + 1, 0);

  List<DateTime> monthsBefore(DateTime other){
    List<DateTime> months = [];

    final limit = DateTime(other.year, other.month);
    DateTime iterator = DateTime(year, month);

    while (iterator.isBeforeOrEqualTo(limit))
    {
      months.add(DateTime(iterator.year, iterator.month));
      iterator = DateTime(iterator.year, iterator.month + 1);
    }
    return months;
  }

  List<DateTime> get listDaysInMonth {
    List<DateTime> days = [];
    for(int i = 0; i < daysInMonth; i++){
      days.add(DateTime(year, month, i + 1));
    }
    return days;
  }

  List<DateTime> daysBefore(DateTime other) {
    List<DateTime> days = [];

    other = other.ignoreTime;
    DateTime iterator = ignoreTime;
    while(iterator.isBeforeOrEqualTo(other)){
      days.add(iterator);
      iterator = iterator.copyWith(day: iterator.day + 1);
    }
    return days;
  }
}

extension DateTimeFormat on DateTime{
  String format(BuildContext context, String format){
    final languageCode = Localizations.localeOf(context).languageCode;
    return DateFormat(format, languageCode).format(this).capitalize;
  }

  String humanFormat(BuildContext context){
    final now = DateTime.now();
    final difference = differenceInDays(now);
    if(difference == -1) return context.l10n.dateTime_yasterday;
    if(difference == 0) return context.l10n.dateTime_today;
    if(difference == 1) return context.l10n.dateTime_tomorrow;
    if(year != now.year) return format(context, "E, dd MMM y");
    return format(context, "E, dd MMM");
  }
}