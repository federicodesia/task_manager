import 'package:json_annotation/json_annotation.dart';
import 'package:task_manager/models/serializers/datetime_serializer.dart';

part 'user.g.dart';

@JsonSerializable()
class User{
  final String id;
  final String email;
  final String name;
  final String? imageUrl;
  @DateTimeSerializer()
  final DateTime createdAt;
  @DateTimeSerializer()
  final DateTime updatedAt;
  final bool verified;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.verified,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}