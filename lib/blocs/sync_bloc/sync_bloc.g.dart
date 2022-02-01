// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncState _$SyncStateFromJson(Map<String, dynamic> json) => SyncState(
      lastTaskPull: nullableDateTimefromJson(json['lastTaskPull'] as String?),
      lastTaskPush: nullableDateTimefromJson(json['lastTaskPush'] as String?),
    );

Map<String, dynamic> _$SyncStateToJson(SyncState instance) => <String, dynamic>{
      'lastTaskPull': nullableDateTimeToJson(instance.lastTaskPull),
      'lastTaskPush': nullableDateTimeToJson(instance.lastTaskPush),
    };
