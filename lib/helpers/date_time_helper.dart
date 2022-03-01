import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/helpers/string_helper.dart';
import 'package:task_manager/l10n/l10n.dart';

DateTime copyDateTimeWith(
  DateTime src,
  {
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
    year ?? src.year,
    month ?? src.month,
    day ?? src.day,
    hour ?? src.hour,
    minute ?? src.minute,
    second ?? src.second,
    millisecond ?? src.millisecond,
    microsecond ?? src.microsecond,
  );
}

int dateDifference(DateTime a, DateTime b) {
  return DateTime(a.year, a.month, a.day).difference(DateTime(b.year, b.month, b.day)).inDays;
}

DateTime getDate(DateTime dateTime) {
  return DateTime(dateTime.year, dateTime.month, dateTime.day);
}

int daysInMonth(DateTime date){
  DateTime thisMonth = DateTime(date.year, date.month, 0);
  DateTime nextMonth = DateTime(date.year, date.month + 1, 0);
  return nextMonth.difference(thisMonth).inDays;
}

extension DateTimeExtension on DateTime {
  String formatLocalization(BuildContext context, {String? format}){
    final languageCode = Localizations.localeOf(context).languageCode;
    return DateFormat(format, languageCode).format(this).capitalize;
  }

  String humanFormat(BuildContext context){
    final now = DateTime.now();
    final difference = dateDifference(this, now);
    if(difference == -1) return context.l10n.dateTime_yasterday;
    if(difference == 0) return context.l10n.dateTime_today;
    if(difference == 1) return context.l10n.dateTime_tomorrow;
    if(year != now.year) return formatLocalization(context, format: "E, dd MMM y");
    return formatLocalization(context, format: "E, dd MMM");
  }
}