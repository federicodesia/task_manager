part of 'task_bloc.dart';

@immutable
abstract class TaskState {}

class TaskLoadInProgress extends TaskState {}

class TaskLoadSuccess extends TaskState {
  final SyncStatus syncPushStatus;
  final List<Task> tasks;
  final List<Task> deletedTasks;
  final List<SyncItemError> failedTasks;

  TaskLoadSuccess({
    this.syncPushStatus = SyncStatus.idle,
    required this.tasks,
    required this.deletedTasks,
    required this.failedTasks
  });

  static TaskLoadSuccess initial(){
    return TaskLoadSuccess(
      syncPushStatus: SyncStatus.idle,
      tasks: [],
      deletedTasks: [],
      failedTasks: []
    );
  }

  TaskLoadSuccess copyWith({
    SyncStatus? syncPushStatus,
    List<Task>? tasks,
    List<Task>? deletedTasks,
    List<SyncItemError>? failedTasks
  }){
    return TaskLoadSuccess(
      syncPushStatus: syncPushStatus ?? SyncStatus.pending,
      tasks: tasks ?? this.tasks,
      deletedTasks: deletedTasks ?? this.deletedTasks,
      failedTasks: failedTasks ?? this.failedTasks
    );
  }
}

class TaskLoadFailure extends TaskState {}