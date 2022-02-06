part of 'category_bloc.dart';

@immutable
abstract class CategoryState {}

class CategoryLoadInProgress extends CategoryState {}

@JsonSerializable()
class CategoryLoadSuccess extends CategoryState {
  final SyncStatus syncPushStatus;
  final List<Category> categories;
  final List<Category> deletedCategories;
  final Map<String, SyncErrorType> failedCategories;

  CategoryLoadSuccess({
    this.syncPushStatus = SyncStatus.idle,
    required this.categories,
    required this.deletedCategories,
    required this.failedCategories
  });

  static CategoryLoadSuccess initial(){
    return CategoryLoadSuccess(
      syncPushStatus: SyncStatus.idle,
      categories: [],
      deletedCategories: [],
      failedCategories: {}
    );
  }

  CategoryLoadSuccess copyWith({
    SyncStatus? syncPushStatus,
    List<Category>? categories,
    List<Category>? deletedCategories,
    Map<String, SyncErrorType>? failedCategories
  }){
    return CategoryLoadSuccess(
      syncPushStatus: syncPushStatus ?? SyncStatus.pending,
      categories: categories ?? this.categories,
      deletedCategories: deletedCategories ?? this.deletedCategories,
      failedCategories: failedCategories ?? this.failedCategories
    );
  }

  factory CategoryLoadSuccess.fromJson(Map<String, dynamic> json) => _$CategoryLoadSuccessFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryLoadSuccessToJson(this);
}

class CategoryLoadFailure extends CategoryState {}