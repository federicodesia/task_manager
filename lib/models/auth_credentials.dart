import 'package:json_annotation/json_annotation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

part 'auth_credentials.g.dart';

@JsonSerializable()
class AuthCredentials{
  final String refreshToken;
  final String accessToken;
  final String passwordToken;

  const AuthCredentials({ 
    this.refreshToken = "",
    this.accessToken = "",
    this.passwordToken = ""
  });

  static const empty = AuthCredentials();

  bool get isEmpty =>
    refreshToken == ""
    && accessToken == ""
    && passwordToken == "";
  
  bool get isNotEmpty => !isEmpty;

  bool get isVerified{
    if(isNotEmpty){
      try{
        return JwtDecoder.decode(accessToken)["verified"];
      }
      catch(_){}
    }
    return false;
  }

  factory AuthCredentials.fromJson(Map<String, dynamic> json) => _$AuthCredentialsFromJson(json);
  Map<String, dynamic> toJson() => _$AuthCredentialsToJson(this);

  AuthCredentials copyWith({
    String? refreshToken,
    String? accessToken,
    String? passwordToken
  }){
    return AuthCredentials(
      refreshToken: refreshToken ?? this.refreshToken,
      accessToken: accessToken ?? this.accessToken,
      passwordToken: passwordToken ?? this.passwordToken
    );
  }
}

extension AuthCredentialsExtension on AuthCredentials{
  AuthCredentials merge(AuthCredentials? other){
    return other != null ? AuthCredentials(
      refreshToken: other.refreshToken.isNotEmpty ? other.refreshToken : refreshToken,
      accessToken: other.accessToken.isNotEmpty ? other.accessToken : accessToken,
      passwordToken: other.passwordToken.isNotEmpty ? other.passwordToken : passwordToken,
    ) : this;
  }
}