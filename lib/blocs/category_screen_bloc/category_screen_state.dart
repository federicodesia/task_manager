part of 'category_screen_bloc.dart';

abstract class CategoryScreenState {}

class CategoryScreenLoadInProgress extends CategoryScreenState {}

class CategoryScreenLoadSuccess extends CategoryScreenState {
  final TaskFilter activeFilter;
  final List<DynamicObject> items;

  CategoryScreenLoadSuccess({
    required this.activeFilter,
    required this.items
  });
}

class CategoryScreenLoadFailure extends CategoryScreenState {}