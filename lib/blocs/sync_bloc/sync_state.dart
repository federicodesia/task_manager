part of 'sync_bloc.dart';

@JsonSerializable()
class SyncState {

  @JsonKey(fromJson: nullableDateTimefromJson, toJson: nullableDateTimeToJson)
  final DateTime? lastTaskPull;

  @JsonKey(fromJson: nullableDateTimefromJson, toJson: nullableDateTimeToJson)
  final DateTime? lastTaskPush;

  SyncState({
    this.lastTaskPull,
    this.lastTaskPush
  });

  SyncState copyWith({
    DateTime? lastTaskPull,
    DateTime? lastTaskPush
  }){
    return SyncState(
      lastTaskPull: lastTaskPull ?? this.lastTaskPull,
      lastTaskPush: lastTaskPush ?? this.lastTaskPush
    );
  }

  factory SyncState.fromJson(Map<String, dynamic> json) => _$SyncStateFromJson(json);
  Map<String, dynamic> toJson() => _$SyncStateToJson(this);
}