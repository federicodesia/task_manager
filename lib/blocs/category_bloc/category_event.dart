part of 'category_bloc.dart';

abstract class CategoryEvent {}

class CategoryLoaded extends CategoryEvent {}

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