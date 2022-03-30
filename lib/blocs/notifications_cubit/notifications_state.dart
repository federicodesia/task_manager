part of 'notifications_cubit.dart';

@JsonSerializable()
class NotificationsState{

  final List<NotificationData> notifications;
  @JsonKey(ignore: true)
  final DateTime? updatedAt;

  NotificationsState({
    required this.notifications,
    this.updatedAt
  });

  static NotificationsState get initial => NotificationsState(
    notifications: [],
    updatedAt: DateTime.now()
  );

  NotificationsState copyWith({
    List<NotificationData>? notifications
  }){
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      updatedAt: DateTime.now()
    );
  }

  factory NotificationsState.fromJson(Map<String, dynamic> json) => _$NotificationsStateFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationsStateToJson(this);
}

extension NotificationDataListExtension on List<NotificationData> {
  List<DynamicObject> get groupByDay {
    List<DynamicObject> items = [];

    final now = DateTime.now();
    final notifications = where((notification) {
      final scheduledAt = notification.scheduledAt;
      return scheduledAt == null || scheduledAt.isBefore(now);
    }).toList();

    notifications.sort((a, b) {
      final aScheduledAt = a.scheduledAt;
      final bScheduledAt = b.scheduledAt;

      if(aScheduledAt != null && bScheduledAt != null){
        return bScheduledAt.compareTo(aScheduledAt);
      }

      if(aScheduledAt == null && bScheduledAt != null) return -1;
      if(aScheduledAt != null && bScheduledAt == null) return 1;
      return b.createdAt.compareTo(a.createdAt);
    });

    if(notifications.isNotEmpty){
      DateTime lastDate = notifications.first.createdAt.ignoreTime;
      items.add(DynamicObject(object: lastDate));

      for (NotificationData notification in notifications){
        if(notification.createdAt.differenceInDays(lastDate) == 0) {
          items.add(DynamicObject(object: notification));
        }
        else{
          lastDate = notification.createdAt.ignoreTime;
          items.add(DynamicObject(object: lastDate));
          items.add(DynamicObject(object: notification));
        }
      }
    }
    return items;
  }
}