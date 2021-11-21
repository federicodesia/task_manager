import 'package:task_manager/models/task.dart';

class TaskGroupHour{
  final DateTime hour;
  final List<Task> tasks;

  TaskGroupHour({
    required this.hour,
    required this.tasks
  });
}