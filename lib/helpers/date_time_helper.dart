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

  int dateDifference(DateTime other) => ignoreTime.difference(other.ignoreTime).inDays;
  
  int get daysInMonth{
    DateTime thisMonth = DateTime(year, month, 0);
    DateTime nextMonth = DateTime(year, month + 1, 0);
    return nextMonth.dateDifference(thisMonth);
  }

  DateTime get lastDayOfMonth => DateTime(year, month + 1, 0);

  List<DateTime> monthsBefore(DateTime other){
    List<DateTime> months = [];

    final limit = DateTime(other.year, other.month);
    DateTime iterator = DateTime(year, month);

    while (iterator.isBefore(limit) || iterator.compareTo(limit) == 0)
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

  String format(BuildContext context, String format){
    final languageCode = Localizations.localeOf(context).languageCode;
    return DateFormat(format, languageCode).format(this).capitalize;
  }

  String humanFormat(BuildContext context){
    final now = DateTime.now();
    final difference = dateDifference(now);
    if(difference == -1) return context.l10n.dateTime_yasterday;
    if(difference == 0) return context.l10n.dateTime_today;
    if(difference == 1) return context.l10n.dateTime_tomorrow;
    if(year != now.year) return format(context, "E, dd MMM y");
    return format(context, "E, dd MMM");
  }
}