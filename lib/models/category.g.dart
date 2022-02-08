// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      id: json['id'] as String?,
      name: json['name'] as String,
      color: const ColorSerializer().fromJson(json['color'] as int),
      createdAt:
          const DateTimeSerializer().fromJson(json['createdAt'] as String),
      updatedAt:
          const DateTimeSerializer().fromJson(json['updatedAt'] as String),
      deletedAt: const NullableDateTimeSerializer()
          .fromJson(json['deletedAt'] as String?),
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'color': const ColorSerializer().toJson(instance.color),
      'createdAt': const DateTimeSerializer().toJson(instance.createdAt),
      'updatedAt': const DateTimeSerializer().toJson(instance.updatedAt),
      'deletedAt':
          const NullableDateTimeSerializer().toJson(instance.deletedAt),
    };
