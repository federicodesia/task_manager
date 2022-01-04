import 'package:json_annotation/json_annotation.dart';

part 'auth_credentials.g.dart';

@JsonSerializable()
class AuthCredentials{
  final String? refreshToken;
  final String? accessToken;

  const AuthCredentials({ 
    this.refreshToken,
    this.accessToken,
  });

  static const empty = AuthCredentials(
    refreshToken: null,
    accessToken: null
  );

  bool get isEmpty => this.refreshToken == null && this.accessToken == null;
  bool get isNotEmpty => !isEmpty;

  factory AuthCredentials.fromJson(Map<String, dynamic> json) => _$AuthCredentialsFromJson(json);
  Map<String, dynamic> toJson() => _$AuthCredentialsToJson(this);
}