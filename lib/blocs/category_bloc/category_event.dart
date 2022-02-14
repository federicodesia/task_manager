part of 'category_bloc.dart';

@immutable
abstract class CategoryEvent {}

class CategoryAdded extends CategoryEvent {
  final Category category;
  CategoryAdded(this.category);
}

class CategoryUpdated extends CategoryEvent {
  final Category category;
  CategoryUpdated(this.category);
}

class CategoryDeleted extends CategoryEvent {
  final Category category;
  CategoryDeleted(this.category);
}

class CategoryStateUpdated extends CategoryEvent {
  final CategoryState state;
  CategoryStateUpdated(this.state);
}

class CategoryReloadStateRequested extends CategoryEvent {
  final Map<String, dynamic>? json;
  CategoryReloadStateRequested({required this.json});
}