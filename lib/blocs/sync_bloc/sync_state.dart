part of 'sync_bloc.dart';

@JsonSerializable()
class SyncState {

  @NullableDateTimeSerializer()
  final DateTime? lastTaskPull;
  @NullableDateTimeSerializer()
  final DateTime? lastTaskPush;

  @NullableDateTimeSerializer()
  final DateTime? lastCategoryPull;
  @NullableDateTimeSerializer()
  final DateTime? lastCategoryPush;

  SyncState({
    this.lastTaskPull,
    this.lastTaskPush,
    this.lastCategoryPull,
    this.lastCategoryPush
  });

  SyncState copyWith({
    DateTime? lastTaskPull,
    DateTime? lastTaskPush,
    DateTime? lastCategoryPull,
    DateTime? lastCategoryPush
  }){
    return SyncState(
      lastTaskPull: lastTaskPull ?? this.lastTaskPull,
      lastTaskPush: lastTaskPush ?? this.lastTaskPush,
      lastCategoryPull: lastCategoryPull ?? this.lastCategoryPull,
      lastCategoryPush: lastCategoryPush ?? this.lastCategoryPush
    );
  }

  factory SyncState.fromJson(Map<String, dynamic> json) => _$SyncStateFromJson(json);
  Map<String, dynamic> toJson() => _$SyncStateToJson(this);
}