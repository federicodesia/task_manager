part of 'notifications_cubit.dart';

@JsonSerializable()
class NotificationsState{

  final List<NotificationData> notifications;
  @JsonKey(ignore: true)
  final List<DynamicObject>? items;

  NotificationsState({
    required this.notifications,
    this.items
  });

  static NotificationsState get initial => NotificationsState(
    notifications: [],
    items: []
  );

  NotificationsState copyWith({
    List<NotificationData>? notifications,
    List<DynamicObject>? items
  }){
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      items: items ?? this.items
    );
  }

  factory NotificationsState.fromJson(Map<String, dynamic> json) => _$NotificationsStateFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationsStateToJson(this);
}