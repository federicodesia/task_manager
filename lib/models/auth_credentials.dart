import 'package:json_annotation/json_annotation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

part 'auth_credentials.g.dart';

@JsonSerializable()
class AuthCredentials{
  final String refreshToken;
  final String accessToken;

  const AuthCredentials({ 
    required this.refreshToken,
    required this.accessToken,
  });

  static const empty = AuthCredentials(
    refreshToken: "",
    accessToken: ""
  );

  bool get isEmpty => this.refreshToken == "" && this.accessToken == "";
  bool get isNotEmpty => !isEmpty;

  bool get isVerified => isNotEmpty && JwtDecoder.decode(accessToken)["verified"];

  factory AuthCredentials.fromJson(Map<String, dynamic> json) => _$AuthCredentialsFromJson(json);
  Map<String, dynamic> toJson() => _$AuthCredentialsToJson(this);
}