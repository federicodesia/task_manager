// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncState _$SyncStateFromJson(Map<String, dynamic> json) => SyncState(
      userId: json['userId'] as String?,
      lastSync: const NullableDateTimeSerializer()
          .fromJson(json['lastSync'] as String?),
    );

Map<String, dynamic> _$SyncStateToJson(SyncState instance) => <String, dynamic>{
      'userId': instance.userId,
      'lastSync': const NullableDateTimeSerializer().toJson(instance.lastSync),
    };
