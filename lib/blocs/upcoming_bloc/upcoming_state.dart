part of 'upcoming_bloc.dart';

abstract class UpcomingState {}

class UpcomingLoadInProgress extends UpcomingState {}

class UpcomingLoadSuccess extends UpcomingState {
  final List<Task> weekTasks;
  final List<TaskGroupDate> groups;

  UpcomingLoadSuccess({
    required this.weekTasks,
    required this.groups
  });
}

class UpcomingLoadFailure extends UpcomingState {}