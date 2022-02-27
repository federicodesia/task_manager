// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeoLocation _$GeoLocationFromJson(Map<String, dynamic> json) => GeoLocation(
      id: json['id'] as int,
      country: json['country'] as String?,
      countryCode: json['countryCode'] as String?,
      region: json['region'] as String?,
      city: json['city'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
      createdAt:
          const DateTimeSerializer().fromJson(json['createdAt'] as String),
    );

Map<String, dynamic> _$GeoLocationToJson(GeoLocation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'country': instance.country,
      'countryCode': instance.countryCode,
      'region': instance.region,
      'city': instance.city,
      'lat': instance.lat,
      'lon': instance.lon,
      'createdAt': const DateTimeSerializer().toJson(instance.createdAt),
    };
