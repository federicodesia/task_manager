// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncState _$SyncStateFromJson(Map<String, dynamic> json) => SyncState(
      lastTaskPull: const NullableDateTimeSerializer()
          .fromJson(json['lastTaskPull'] as String?),
      lastTaskPush: const NullableDateTimeSerializer()
          .fromJson(json['lastTaskPush'] as String?),
      lastCategoryPull: const NullableDateTimeSerializer()
          .fromJson(json['lastCategoryPull'] as String?),
      lastCategoryPush: const NullableDateTimeSerializer()
          .fromJson(json['lastCategoryPush'] as String?),
    );

Map<String, dynamic> _$SyncStateToJson(SyncState instance) => <String, dynamic>{
      'lastTaskPull':
          const NullableDateTimeSerializer().toJson(instance.lastTaskPull),
      'lastTaskPush':
          const NullableDateTimeSerializer().toJson(instance.lastTaskPush),
      'lastCategoryPull':
          const NullableDateTimeSerializer().toJson(instance.lastCategoryPull),
      'lastCategoryPush':
          const NullableDateTimeSerializer().toJson(instance.lastCategoryPush),
    };
