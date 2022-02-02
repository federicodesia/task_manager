part of 'task_bloc.dart';

@immutable
abstract class TaskState {}

class TaskLoadInProgress extends TaskState {}

class TaskLoadSuccess extends TaskState {
  final SyncPushStatus syncPushStatus;
  final List<Task> tasks;
  final List<Task> deletedTasks;

  TaskLoadSuccess({
    required this.tasks,
    required this.deletedTasks,
    this.syncPushStatus = SyncPushStatus.idle,
  });

  TaskLoadSuccess copyWith({
    SyncPushStatus? syncPushStatus,
    List<Task>? tasks,
    List<Task>? deletedTasks
  }){
    return TaskLoadSuccess(
      syncPushStatus: syncPushStatus ?? SyncPushStatus.pending,
      tasks: tasks ?? this.tasks,
      deletedTasks: deletedTasks ?? this.deletedTasks
    );
  }
}

class TaskLoadFailure extends TaskState {}