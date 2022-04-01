// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryState _$CategoryStateFromJson(Map<String, dynamic> json) =>
    CategoryState(
      isLoading: json['isLoading'] as bool,
      userId: json['userId'] as String?,
      syncStatus: $enumDecode(_$SyncStatusEnumMap, json['syncStatus']),
      categories: (json['categories'] as List<dynamic>)
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
      deletedCategories: (json['deletedCategories'] as List<dynamic>)
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
      failedCategories: (json['failedCategories'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, $enumDecode(_$SyncErrorTypeEnumMap, e)),
      ),
    );

Map<String, dynamic> _$CategoryStateToJson(CategoryState instance) =>
    <String, dynamic>{
      'isLoading': instance.isLoading,
      'userId': instance.userId,
      'syncStatus': _$SyncStatusEnumMap[instance.syncStatus],
      'categories': instance.categories,
      'deletedCategories': instance.deletedCategories,
      'failedCategories': instance.failedCategories
          .map((k, e) => MapEntry(k, _$SyncErrorTypeEnumMap[e])),
    };

const _$SyncStatusEnumMap = {
  SyncStatus.idle: 'idle',
  SyncStatus.pending: 'pending',
};

const _$SyncErrorTypeEnumMap = {
  SyncErrorType.duplicatedId: 'duplicatedId',
  SyncErrorType.blacklist: 'blacklist',
};
