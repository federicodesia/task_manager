part of 'task_bloc.dart';

abstract class TaskEvent {}

class TaskLoaded extends TaskEvent {}

class TaskAdded extends TaskEvent {
  final Task task;
  TaskAdded(this.task);
}

class TaskUpdated extends TaskEvent {
  final Task task;
  TaskUpdated(this.task);
}

class TaskDeleted extends TaskEvent {
  final Task task;
  TaskDeleted(this.task);
}

class TaskUndoDeleted extends TaskEvent {
  final Task task;
  TaskUndoDeleted(this.task);
}

class TasksUpdated extends TaskEvent {
  final List<Task> tasks;
  TasksUpdated(this.tasks);
}

class TaskStateUpdated extends TaskEvent {
  final TaskState state;
  TaskStateUpdated(this.state);
}

class ScheduleTaskNotificationsRequested extends TaskEvent {}