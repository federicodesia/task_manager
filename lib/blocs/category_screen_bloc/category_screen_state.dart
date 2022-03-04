part of 'category_screen_bloc.dart';

class CategoryScreenState {
  final String searchText;
  final TaskFilter activeFilter;
  final List<DynamicObject> items;

  CategoryScreenState({
    this.searchText = "",
    this.activeFilter = TaskFilter.all,
    this.items = const []
  });

  CategoryScreenState copyWith({
    String? searchText,
    TaskFilter? activeFilter,
    List<DynamicObject>? items
  }){
    return CategoryScreenState(
      searchText: searchText ?? this.searchText,
      activeFilter: activeFilter ?? this.activeFilter,
      items: items ?? this.items,
    );
  }
}