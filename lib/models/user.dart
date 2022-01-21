import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User{
  final String id;
  final String email;
  final String name;
  final String? imageUrl;
  final String createdAt;
  final String updatedAt;
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

  static const empty = User(
    id: "",
    email: "",
    name: "",
    createdAt: "",
    updatedAt: "",
    verified: false
  );

  bool get isEmpty =>
    this.id == ""
    && this.email == ""
    && this.name == ""
    && this.imageUrl == null
    && this.createdAt == ""
    && this.updatedAt == ""
    && this.verified == false;

  bool get isNotEmpty => !isEmpty;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}