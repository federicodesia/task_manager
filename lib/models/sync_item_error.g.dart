// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_item_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncItemError _$SyncItemErrorFromJson(Map<String, dynamic> json) =>
    SyncItemError(
      id: json['id'] as String,
      error: $enumDecode(_$SyncErrorTypeEnumMap, json['error']),
    );

Map<String, dynamic> _$SyncItemErrorToJson(SyncItemError instance) =>
    <String, dynamic>{
      'id': instance.id,
      'error': _$SyncErrorTypeEnumMap[instance.error],
    };

const _$SyncErrorTypeEnumMap = {
  SyncErrorType.duplicatedId: 'duplicatedId',
  SyncErrorType.blacklist: 'blacklist',
};
