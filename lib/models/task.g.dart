// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      id: json['id'] as String,
      categoryId: json['categoryId'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      date: dateTimefromJson(json['date'] as String),
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: dateTimefromJson(json['createdAt'] as String),
      updatedAt: dateTimefromJson(json['updatedAt'] as String),
      deletedAt: nullableDateTimefromJson(json['deletedAt'] as String?),
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'categoryId': instance.categoryId,
      'title': instance.title,
      'description': instance.description,
      'date': dateTimeToJson(instance.date),
      'isCompleted': instance.isCompleted,
      'createdAt': dateTimeToJson(instance.createdAt),
      'updatedAt': dateTimeToJson(instance.updatedAt),
      'deletedAt': nullableDateTimeToJson(instance.deletedAt),
    };
