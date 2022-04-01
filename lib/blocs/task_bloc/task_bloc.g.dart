// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskState _$TaskStateFromJson(Map<String, dynamic> json) => TaskState(
      isLoading: json['isLoading'] as bool,
      userId: json['userId'] as String?,
      syncStatus: $enumDecode(_$SyncStatusEnumMap, json['syncStatus']),
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

Map<String, dynamic> _$TaskStateToJson(TaskState instance) => <String, dynamic>{
      'isLoading': instance.isLoading,
      'userId': instance.userId,
      'syncStatus': _$SyncStatusEnumMap[instance.syncStatus],
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
