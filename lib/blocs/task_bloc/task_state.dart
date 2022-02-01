part of 'task_bloc.dart';

@immutable
abstract class TaskState {}

class TaskLoadInProgress extends TaskState {}

class TaskLoadSuccess extends TaskState {
  final SyncPushStatus syncPushStatus;
  final List<Task> tasks;

  TaskLoadSuccess({
    this.tasks = const [],
    this.syncPushStatus = SyncPushStatus.idle,
  });

  TaskLoadSuccess copyWith({
    SyncPushStatus? syncPushStatus,
    List<Task>? tasks
  }){
    return TaskLoadSuccess(
      syncPushStatus: syncPushStatus ?? SyncPushStatus.pending,
      tasks: tasks ?? this.tasks
    );
  }
}

class TaskLoadFailure extends TaskState {}