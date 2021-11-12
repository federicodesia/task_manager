import 'package:task_manager/helpers/date_time_helper.dart';

class Task{
  final String uuid;
  final String title;
  final String description;
  DateTime? date;
  DateTime? time;
  final bool completed;

  Task({ 
    required this.uuid,
    this.title = "",
    this.description = "",
    this.date,
    this.time,
    this.completed = false 
  });

  DateTime get dateTime => copyDateTimeWith(
    this.date!,
    hour: this.time!.hour,
    minute: this.time!.minute,
  );

  void setDateTime(DateTime dateTime){
    this.date = dateTime;
    this.time = dateTime;
  }

  Task copyWith({String? title, String? description, DateTime? date, DateTime? time, bool? completed}){
    return Task(
      uuid: this.uuid,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      completed: completed ?? this.completed
    );
  }
}