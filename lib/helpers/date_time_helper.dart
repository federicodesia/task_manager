DateTime copyDateTimeWith(
  DateTime src,
  {
    int year,
    int month,
    int day,
    int hour,
    int minute,
    int second,
    int millisecond,
    int microsecond
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

int dateDifference(DateTime date) {
  DateTime now = DateTime.now();
  return DateTime(date.year, date.month, date.day).difference(DateTime(now.year, now.month, now.day)).inDays;
}