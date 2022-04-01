part of 'task_bloc.dart';

@JsonSerializable()
class TaskState {

  final bool isLoading;
  final String? userId;
  final SyncStatus syncStatus;
  final List<Task> tasks;
  final List<Task> deletedTasks;
  final Map<String, SyncErrorType> failedTasks;

  TaskState({
    required this.isLoading,
    required this.userId,
    required this.syncStatus,
    required this.tasks,
    required this.deletedTasks,
    required this.failedTasks
  });

  static TaskState get initial => TaskState(
    isLoading: true,
    userId: null,
    syncStatus: SyncStatus.idle,
    tasks: [],
    deletedTasks: [],
    failedTasks: {}
  );

  TaskState copyWith({
    bool? isLoading,
    String? userId,
    SyncStatus? syncStatus,
    List<Task>? tasks,
    List<Task>? deletedTasks,
    Map<String, SyncErrorType>? failedTasks
  }){
    return TaskState(
      isLoading: isLoading ?? this.isLoading,
      userId: userId ?? this.userId,
      syncStatus: syncStatus ?? SyncStatus.pending,
      tasks: tasks ?? this.tasks,
      deletedTasks: deletedTasks ?? this.deletedTasks,
      failedTasks: failedTasks ?? this.failedTasks
    );
  }

  factory TaskState.fromJson(Map<String, dynamic> json) => _$TaskStateFromJson(json);
  Map<String, dynamic> toJson() => _$TaskStateToJson(this);
}