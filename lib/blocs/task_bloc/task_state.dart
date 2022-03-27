part of 'task_bloc.dart';

abstract class TaskState {}

class TaskLoadInProgress extends TaskState {}

@JsonSerializable()
class TaskLoadSuccess extends TaskState {

  final SyncStatus syncPushStatus;
  final List<Task> tasks;
  final List<Task> deletedTasks;
  final Map<String, SyncErrorType> failedTasks;

  TaskLoadSuccess({
    required this.syncPushStatus,
    required this.tasks,
    required this.deletedTasks,
    required this.failedTasks
  });

  static TaskLoadSuccess get initial => TaskLoadSuccess(
    syncPushStatus: SyncStatus.idle,
    tasks: [],
    deletedTasks: [],
    failedTasks: {}
  );

  TaskLoadSuccess copyWith({
    SyncStatus? syncPushStatus,
    List<Task>? tasks,
    List<Task>? deletedTasks,
    Map<String, SyncErrorType>? failedTasks
  }){
    return TaskLoadSuccess(
      syncPushStatus: syncPushStatus ?? SyncStatus.pending,
      tasks: tasks ?? this.tasks,
      deletedTasks: deletedTasks ?? this.deletedTasks,
      failedTasks: failedTasks ?? this.failedTasks
    );
  }

  factory TaskLoadSuccess.fromJson(Map<String, dynamic> json) => _$TaskLoadSuccessFromJson(json);
  Map<String, dynamic> toJson() => _$TaskLoadSuccessToJson(this);
}

class TaskLoadFailure extends TaskState {}