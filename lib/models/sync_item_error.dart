import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sync_item_error.g.dart';

enum SyncErrorType { 
  @JsonValue("duplicatedId") duplicatedId,
  @JsonValue("blacklist") blacklist
}

@JsonSerializable()
class SyncItemError extends Equatable{
  final String id;
  final SyncErrorType error;

  SyncItemError({
    required this.id,
    required this.error
  });

  SyncItemError copyWith({
    String? id,
    SyncErrorType? error
  }){
    return SyncItemError(
      id: id ?? this.id,
      error: error ?? this.error
    );
  }

  factory SyncItemError.fromJson(Map<String, dynamic> json) => _$SyncItemErrorFromJson(json);
  Map<String, dynamic> toJson() => _$SyncItemErrorToJson(this);

  @override
  List<Object?> get props => [id, error];

  @override
  bool get stringify => true;
}