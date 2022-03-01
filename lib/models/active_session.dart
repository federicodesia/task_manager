import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:task_manager/models/geo_location.dart';
import 'package:task_manager/models/serializers/datetime_serializer.dart';

part 'active_session.g.dart';

@JsonSerializable()
class ActiveSession extends Equatable{

  final int id;
  final String token;
  @DateTimeSerializer()
  final DateTime lastTimeOfUse;
  final String ipAddress;
  @DateTimeSerializer()
  final DateTime createdAt;
  final GeoLocation? geoLocation;
  final bool isThisDevice;

  const ActiveSession({
    required this.id,
    required this.token,
    required this.lastTimeOfUse,
    required this.ipAddress,
    required this.createdAt,
    this.geoLocation,
    this.isThisDevice = false
  });

  ActiveSession copyWith({
    bool? isThisDevice
  }){
    return ActiveSession(
      id: id,
      token: token,
      lastTimeOfUse: lastTimeOfUse,
      ipAddress: ipAddress,
      createdAt: createdAt,
      geoLocation: geoLocation,
      isThisDevice: isThisDevice ?? this.isThisDevice
    );
  }

  factory ActiveSession.fromJson(Map<String, dynamic> json) => _$ActiveSessionFromJson(json);
  Map<String, dynamic> toJson() => _$ActiveSessionToJson(this);

  @override
  List<Object?> get props => [id, token, lastTimeOfUse, ipAddress, createdAt, geoLocation, isThisDevice];

  @override
  bool get stringify => true;
}