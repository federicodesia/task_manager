part of 'upcoming_bloc.dart';

abstract class UpcomingState {}

class UpcomingLoadInProgress extends UpcomingState {}

class UpcomingLoadSuccess extends UpcomingState {
  final Map<DateTime, int> weekTasks;
  final Map<DateTime, int> weekCompletedTasks;
  final int weekCompletedTasksCount;
  final int weekRemainingTasksCount;
  final List<DynamicObject> items;

  UpcomingLoadSuccess({
    required this.weekTasks,
    required this.weekCompletedTasks,
    required this.weekCompletedTasksCount,
    required this.weekRemainingTasksCount,
    required this.items
  });
}