part of 'notifications_cubit.dart';

@JsonSerializable()
class NotificationsState{

  final List<NotificationData> notifications;

  NotificationsState({
    required this.notifications
  });

  static NotificationsState get initial => NotificationsState(
    notifications: []
  );

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

extension NotificationDataListExtension on List<NotificationData> {
  List<DynamicObject> get groupByDay {
    List<DynamicObject> items = [];

    final now = DateTime.now();
    removeWhere((notification) {
      final scheduledAt = notification.scheduledAt;
      return scheduledAt != null && scheduledAt.isAfter(now);
    });
    sort((a, b) => b.createdAt.compareTo(a.createdAt));

    if(isNotEmpty){
      DateTime lastDate = first.createdAt.ignoreTime;
      items.add(DynamicObject(object: lastDate));

      for (NotificationData notification in this){
        if(notification.createdAt.dateDifference(lastDate) == 0) {
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