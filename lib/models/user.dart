import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User{
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String imageUrl;
  final String createdAt;
  final String updatedAt;
  final String verified;

  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.verified,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}