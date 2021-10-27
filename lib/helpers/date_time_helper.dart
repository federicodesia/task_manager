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

int dateDifference(DateTime a, DateTime b) {
  return DateTime(a.year, a.month, a.day).difference(DateTime(b.year, b.month, b.day)).inDays;
}

DateTime getDate(DateTime dateTime) {
  return DateTime(dateTime.year, dateTime.month, dateTime.day);
}