part of 'category_screen_bloc.dart';

abstract class CategoryScreenEvent {}

class CategoryScreenLoaded extends CategoryScreenEvent {}

class SearchTextChanged extends CategoryScreenEvent {
  final String searchText;
  SearchTextChanged(this.searchText);
}

class FilterUpdated extends CategoryScreenEvent {
  final TaskFilter taskFilter;
  FilterUpdated(this.taskFilter);
}

class UpdateItemsRequested extends CategoryScreenEvent{
  final String? searchText;
  final TaskFilter? taskFilter;
  final List<Task>? tasks;

  UpdateItemsRequested({
    this.searchText,
    this.taskFilter,
    this.tasks
  });
}