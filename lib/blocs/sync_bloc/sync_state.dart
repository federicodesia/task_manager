part of 'sync_bloc.dart';

@JsonSerializable()
class SyncState {

  @NullableDateTimeSerializer()
  final DateTime? lastSync;

  SyncState({this.lastSync});

  SyncState copyWith({
    DateTime? lastSync
  }){
    return SyncState(
      lastSync: lastSync ?? this.lastSync
    );
  }

  factory SyncState.fromJson(Map<String, dynamic> json) => _$SyncStateFromJson(json);
  Map<String, dynamic> toJson() => _$SyncStateToJson(this);
}