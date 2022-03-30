part of 'category_bloc.dart';

@JsonSerializable()
class CategoryState{

  final bool isLoading;
  final SyncStatus syncStatus;
  final List<Category> categories;
  final List<Category> deletedCategories;
  final Map<String, SyncErrorType> failedCategories;

  CategoryState({
    required this.isLoading,
    required this.syncStatus,
    required this.categories,
    required this.deletedCategories,
    required this.failedCategories
  });

  static CategoryState get initial => CategoryState(
    isLoading: true,
    syncStatus: SyncStatus.idle,
    categories: [
      Category.create(
        isGeneral: true,
        name: "General",
        color: Colors.grey.withOpacity(0.65)
      )
    ],
    deletedCategories: [],
    failedCategories: {}
  );

  CategoryState copyWith({
    bool? isLoading,
    SyncStatus? syncStatus,
    List<Category>? categories,
    List<Category>? deletedCategories,
    Map<String, SyncErrorType>? failedCategories
  }){
    return CategoryState(
      isLoading: isLoading ?? this.isLoading,
      syncStatus: syncStatus ?? SyncStatus.pending,
      categories: categories ?? this.categories,
      deletedCategories: deletedCategories ?? this.deletedCategories,
      failedCategories: failedCategories ?? this.failedCategories
    );
  }

  factory CategoryState.fromJson(Map<String, dynamic> json) => _$CategoryStateFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryStateToJson(this);
}