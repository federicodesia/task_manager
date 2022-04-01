part of 'sync_bloc.dart';

@JsonSerializable()
class SyncState {

  final String? userId;
  @NullableDateTimeSerializer()
  final DateTime? lastSync;

  SyncState({
    required this.userId,
    required this.lastSync
  });

  static SyncState get initial => SyncState(
    userId: null,
    lastSync: null
  );

  SyncState copyWith({
    String? userId,
    DateTime? lastSync
  }){
    return SyncState(
      userId: userId ?? this.userId,
      lastSync: lastSync ?? this.lastSync
    );
  }

  factory SyncState.fromJson(Map<String, dynamic> json) => _$SyncStateFromJson(json);
  Map<String, dynamic> toJson() => _$SyncStateToJson(this);
}