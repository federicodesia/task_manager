part of 'task_bloc.dart';

@immutable
abstract class TaskState {}

class TaskLoadInProgress extends TaskState {}

class TaskLoadSuccess extends TaskState {
  final List<Task> tasks;
  TaskLoadSuccess([this.tasks = const []]);
}

class TaskLoadFailure extends TaskState {}