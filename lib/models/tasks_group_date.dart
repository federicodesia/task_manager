import 'package:task_manager/models/task.dart';

class TaskGroupDate{
  final DateTime dateTime;
  final List<Task> tasks;

  TaskGroupDate({
    required this.dateTime,
    required this.tasks
  });
}