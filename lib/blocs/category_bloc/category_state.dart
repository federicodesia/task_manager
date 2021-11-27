part of 'category_bloc.dart';

@immutable
abstract class CategoryState {}

class CategoryLoadInProgress extends CategoryState {}

class CategoryLoadSuccess extends CategoryState {
  final List<Category> categories;
  CategoryLoadSuccess([this.categories = const []]);
}

class CategoryLoadFailure extends CategoryState {}