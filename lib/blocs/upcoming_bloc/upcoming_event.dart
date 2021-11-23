part of 'upcoming_bloc.dart';

abstract class UpcomingEvent {}

class UpcomingLoaded extends UpcomingEvent {
  UpcomingLoaded();
}

class TasksUpdated extends UpcomingEvent {
  final List<Task> tasks;
  TasksUpdated(this.tasks);
}