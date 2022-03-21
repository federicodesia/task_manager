// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GeneralNotification _$$GeneralNotificationFromJson(
        Map<String, dynamic> json) =>
    _$GeneralNotification(
      color: json['color'] == null
          ? const Color(0xFF008FFD)
          : const ColorSerializer().fromJson(json['color'] as int),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$GeneralNotificationToJson(
        _$GeneralNotification instance) =>
    <String, dynamic>{
      'color': const ColorSerializer().toJson(instance.color),
      'runtimeType': instance.$type,
    };

_$ReminderNotification _$$ReminderNotificationFromJson(
        Map<String, dynamic> json) =>
    _$ReminderNotification(
      color: json['color'] == null
          ? const Color(0xFF5C5D9D)
          : const ColorSerializer().fromJson(json['color'] as int),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$ReminderNotificationToJson(
        _$ReminderNotification instance) =>
    <String, dynamic>{
      'color': const ColorSerializer().toJson(instance.color),
      'runtimeType': instance.$type,
    };

_$SecurityNotification _$$SecurityNotificationFromJson(
        Map<String, dynamic> json) =>
    _$SecurityNotification(
      color: json['color'] == null
          ? const Color(0xFFFF8700)
          : const ColorSerializer().fromJson(json['color'] as int),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$SecurityNotificationToJson(
        _$SecurityNotification instance) =>
    <String, dynamic>{
      'color': const ColorSerializer().toJson(instance.color),
      'runtimeType': instance.$type,
    };

_$AdvertisementNotification _$$AdvertisementNotificationFromJson(
        Map<String, dynamic> json) =>
    _$AdvertisementNotification(
      color: json['color'] == null
          ? const Color(0xFFFFBF47)
          : const ColorSerializer().fromJson(json['color'] as int),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$AdvertisementNotificationToJson(
        _$AdvertisementNotification instance) =>
    <String, dynamic>{
      'color': const ColorSerializer().toJson(instance.color),
      'runtimeType': instance.$type,
    };
