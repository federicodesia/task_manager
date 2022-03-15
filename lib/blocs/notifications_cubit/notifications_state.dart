part of 'notifications_cubit.dart';

@JsonSerializable()
class NotificationsState{

  final List<NotificationData> notifications;

  NotificationsState({
    this.notifications = const [],
  });

  NotificationsState copyWith({
    List<NotificationData>? notifications
  }){
    return NotificationsState(
      notifications: notifications ?? this.notifications
    );
  }

  factory NotificationsState.fromJson(Map<String, dynamic> json) => _$NotificationsStateFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationsStateToJson(this);
}