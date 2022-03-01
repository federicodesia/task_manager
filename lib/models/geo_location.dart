import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:task_manager/models/serializers/datetime_serializer.dart';

part 'geo_location.g.dart';

@JsonSerializable()
class GeoLocation extends Equatable{

  final int id;
  final String? country;
  final String? countryCode;
  final String? region;
  final String? city;
  final double? lat;
  final double? lon;
  @DateTimeSerializer()
  final DateTime createdAt;

  const GeoLocation({
    required this.id,
    this.country,
    this.countryCode,
    this.region,
    this.city,
    this.lat,
    this.lon,
    required this.createdAt
  });

  factory GeoLocation.fromJson(Map<String, dynamic> json) => _$GeoLocationFromJson(json);
  Map<String, dynamic> toJson() => _$GeoLocationToJson(this);

  @override
  List<Object?> get props => [id, country, countryCode, region, city, lat, lon, createdAt];

  @override
  bool get stringify => true;
}