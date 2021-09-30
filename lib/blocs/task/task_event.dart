part of 'task_bloc.dart';

@immutable
abstract class TaskEvent {}

class TaskLoaded extends TaskEvent {}

class TaskAdded extends TaskEvent {
  final Task task;
  TaskAdded(this.task);
}

class TaskUpdated extends TaskEvent {
  final Task oldTask;
  final Task taskUpdated;
  TaskUpdated({required this.oldTask, required this.taskUpdated});
}

class TaskDeleted extends TaskEvent {
  final Task task;
  TaskDeleted(this.task);
}

class TaskCompleted extends TaskEvent {
  final Task task;
  final bool value;
  TaskCompleted({required this.task, required this.value});
}