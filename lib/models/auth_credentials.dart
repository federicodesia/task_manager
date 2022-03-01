import 'package:json_annotation/json_annotation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:task_manager/helpers/enum_helper.dart';

part 'auth_credentials.g.dart';

enum TokenType { refresh, access, password }

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

  bool get isVerified{
    if(isNotEmpty){
      try{
        return JwtDecoder.decode(accessToken)["verified"];
      }
      catch(_){
        return false;
      }
    }
    return false;
  }

  TokenType? get accessTokenType{
    if(accessToken != ""){
      try{
        final String type = JwtDecoder.decode(accessToken)["type"];
        return enumFromString(TokenType.values, type);
      }
      catch(_){}
    }
    return null;
  }

  factory AuthCredentials.fromJson(Map<String, dynamic> json) => _$AuthCredentialsFromJson(json);
  Map<String, dynamic> toJson() => _$AuthCredentialsToJson(this);

  AuthCredentials copyWith({
    String? refreshToken,
    String? accessToken
  }){
    return AuthCredentials(
      refreshToken: refreshToken ?? this.refreshToken,
      accessToken: accessToken ?? this.accessToken
    );
  }
}