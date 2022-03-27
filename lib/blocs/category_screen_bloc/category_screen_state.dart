part of 'category_screen_bloc.dart';

class CategoryScreenState {
  final String searchText;
  final TaskFilter activeFilter;
  final List<DynamicObject> items;

  CategoryScreenState({
    required this.searchText,
    required this.activeFilter,
    required this.items
  });

  static CategoryScreenState get initial => CategoryScreenState(
    searchText: "",
    activeFilter: TaskFilter.all,
    items: []
  );

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