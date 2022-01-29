part of 'task_bloc.dart';

@immutable
abstract class TaskState {}

class TaskLoadInProgress extends TaskState {}

class TaskLoadSuccess extends TaskState {
  final DateTime? lastSyncPull;
  final DateTime? lastSyncPush;
  final List<Task> tasks;

  TaskLoadSuccess({
    this.tasks = const [],
    this.lastSyncPull,
    this.lastSyncPush
  });

  TaskLoadSuccess copyWith({
    DateTime? lastSyncPull,
    DateTime? lastSyncPush,
    List<Task>? tasks
  }){
    return TaskLoadSuccess(
      lastSyncPull: lastSyncPull ?? this.lastSyncPull,
      lastSyncPush: lastSyncPush ?? this.lastSyncPush,
      tasks: tasks ?? this.tasks
    );
  }
}

class TaskLoadFailure extends TaskState {}