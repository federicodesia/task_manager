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

bool isToday(DateTime dateTime){
  return DateTime.now().difference(dateTime).inDays == 0;
}