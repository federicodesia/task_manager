// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthState _$AuthStateFromJson(Map<String, dynamic> json) => AuthState(
      status: $enumDecodeNullable(_$AuthStatusEnumMap, json['status']) ??
          AuthStatus.loading,
      user: json['user'] == null
          ? User.empty
          : User.fromJson(json['user'] as Map<String, dynamic>),
      activeSessions: (json['activeSessions'] as List<dynamic>?)
              ?.map((e) => ActiveSession.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$AuthStateToJson(AuthState instance) => <String, dynamic>{
      'status': _$AuthStatusEnumMap[instance.status],
      'user': instance.user,
      'activeSessions': instance.activeSessions,
    };

const _$AuthStatusEnumMap = {
  AuthStatus.loading: 'loading',
  AuthStatus.unauthenticated: 'unauthenticated',
  AuthStatus.waitingVerification: 'waitingVerification',
  AuthStatus.authenticated: 'authenticated',
};
