// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
      createdAt:
          const DateTimeSerializer().fromJson(json['createdAt'] as String),
      updatedAt:
          const DateTimeSerializer().fromJson(json['updatedAt'] as String),
      verified: json['verified'] as bool,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'createdAt': const DateTimeSerializer().toJson(instance.createdAt),
      'updatedAt': const DateTimeSerializer().toJson(instance.updatedAt),
      'verified': instance.verified,
    };
