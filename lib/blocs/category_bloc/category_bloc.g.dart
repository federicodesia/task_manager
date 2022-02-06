// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryLoadSuccess _$CategoryLoadSuccessFromJson(Map<String, dynamic> json) =>
    CategoryLoadSuccess(
      syncPushStatus:
          $enumDecodeNullable(_$SyncStatusEnumMap, json['syncPushStatus']) ??
              SyncStatus.idle,
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

Map<String, dynamic> _$CategoryLoadSuccessToJson(
        CategoryLoadSuccess instance) =>
    <String, dynamic>{
      'syncPushStatus': _$SyncStatusEnumMap[instance.syncPushStatus],
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
