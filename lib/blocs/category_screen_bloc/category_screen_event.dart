part of 'category_screen_bloc.dart';

abstract class CategoryScreenEvent {}

class CategoryScreenLoaded extends CategoryScreenEvent {
  CategoryScreenLoaded();
}

class CategoryScreenFilterUpdated extends CategoryScreenEvent {
  final TaskFilter filter;
  CategoryScreenFilterUpdated({required this.filter});
}

class TasksUpdated extends CategoryScreenEvent {
  final List<Task> tasks;
  TasksUpdated(this.tasks);
}