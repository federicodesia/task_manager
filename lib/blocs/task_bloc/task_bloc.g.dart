// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskLoadSuccess _$TaskLoadSuccessFromJson(Map<String, dynamic> json) =>
    TaskLoadSuccess(
      syncPushStatus:
          $enumDecodeNullable(_$SyncStatusEnumMap, json['syncPushStatus']) ??
              SyncStatus.idle,
      tasks: (json['tasks'] as List<dynamic>)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList(),
      deletedTasks: (json['deletedTasks'] as List<dynamic>)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList(),
      failedTasks: (json['failedTasks'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, $enumDecode(_$SyncErrorTypeEnumMap, e)),
      ),
    );

Map<String, dynamic> _$TaskLoadSuccessToJson(TaskLoadSuccess instance) =>
    <String, dynamic>{
      'syncPushStatus': _$SyncStatusEnumMap[instance.syncPushStatus],
      'tasks': instance.tasks,
      'deletedTasks': instance.deletedTasks,
      'failedTasks': instance.failedTasks
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
