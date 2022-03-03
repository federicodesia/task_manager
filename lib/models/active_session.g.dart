// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActiveSession _$ActiveSessionFromJson(Map<String, dynamic> json) =>
    ActiveSession(
      id: json['id'] as int,
      token: json['token'] as String,
      lastTimeOfUse:
          const DateTimeSerializer().fromJson(json['lastTimeOfUse'] as String),
      ipAddress: json['ipAddress'] as String,
      createdAt:
          const DateTimeSerializer().fromJson(json['createdAt'] as String),
      geoLocation: json['geoLocation'] == null
          ? null
          : GeoLocation.fromJson(json['geoLocation'] as Map<String, dynamic>),
      deviceName: json['deviceName'] as String,
      isThisDevice: json['isThisDevice'] as bool? ?? false,
    );

Map<String, dynamic> _$ActiveSessionToJson(ActiveSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'token': instance.token,
      'lastTimeOfUse':
          const DateTimeSerializer().toJson(instance.lastTimeOfUse),
      'ipAddress': instance.ipAddress,
      'createdAt': const DateTimeSerializer().toJson(instance.createdAt),
      'geoLocation': instance.geoLocation,
      'deviceName': instance.deviceName,
      'isThisDevice': instance.isThisDevice,
    };
