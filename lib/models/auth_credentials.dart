import 'package:json_annotation/json_annotation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

part 'auth_credentials.g.dart';

@JsonSerializable()
class AuthCredentials{
  final String? refreshToken;
  final String? accessToken;

  const AuthCredentials({ 
    this.refreshToken,
    this.accessToken,
  });

  bool get isEmpty => this.refreshToken == null && this.accessToken == null;
  bool get isNotEmpty => !isEmpty;

  bool get isVerified => accessToken != null ? JwtDecoder.decode(accessToken!)["verified"] : false;

  factory AuthCredentials.fromJson(Map<String, dynamic> json) => _$AuthCredentialsFromJson(json);
  Map<String, dynamic> toJson() => _$AuthCredentialsToJson(this);
}