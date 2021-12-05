part of 'upcoming_bloc.dart';

abstract class UpcomingState {}

class UpcomingLoadInProgress extends UpcomingState {}

class UpcomingLoadSuccess extends UpcomingState {
  final List<Task> weekTasks;
  final List<DynamicObject> items;

  UpcomingLoadSuccess({
    required this.weekTasks,
    required this.items
  });
}

class UpcomingLoadFailure extends UpcomingState {}