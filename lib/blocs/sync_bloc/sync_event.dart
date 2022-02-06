part of 'sync_bloc.dart';

@immutable
abstract class SyncEvent {}

class SyncPullTaskRequested extends SyncEvent {}
class SyncPushTaskRequested extends SyncEvent {
  final List<Task> tasks;
  final Map<String, SyncErrorType> failedTasks;

  SyncPushTaskRequested({
    required this.tasks,
    required this.failedTasks
  });
}

class SyncPullCategoryRequested extends SyncEvent {}
class SyncPushCategoryRequested extends SyncEvent {
  final List<Category> categories;
  final Map<String, SyncErrorType> failedCategories;

  SyncPushCategoryRequested({
    required this.categories,
    required this.failedCategories
  });
}
