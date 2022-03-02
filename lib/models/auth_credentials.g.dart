// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_credentials.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthCredentials _$AuthCredentialsFromJson(Map<String, dynamic> json) =>
    AuthCredentials(
      refreshToken: json['refreshToken'] as String? ?? "",
      accessToken: json['accessToken'] as String? ?? "",
      passwordToken: json['passwordToken'] as String? ?? "",
    );

Map<String, dynamic> _$AuthCredentialsToJson(AuthCredentials instance) =>
    <String, dynamic>{
      'refreshToken': instance.refreshToken,
      'accessToken': instance.accessToken,
      'passwordToken': instance.passwordToken,
    };
