import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:task_manager/helpers/string_helper.dart';
import 'package:task_manager/models/notification_type.dart';

class NotificationService{

  late Map<NotificationType, NotificationChannel> channels = {
    for (var type in [
      const NotificationType.general(),
      const NotificationType.reminder(),
      const NotificationType.security(),
      const NotificationType.advertisement()
    ]) type : _channelFromType(type)
  };

  NotificationChannel _channelFromType(NotificationType type){
    final name = (type.toJson()["runtimeType"] as String?) ?? "basic";
    return NotificationChannel(
      channelKey: "$name channel".toLowerSnakeCase,
      channelName: "${name.capitalize} notifications",
      channelDescription: "Description not provided",
      defaultColor: type.color
    );
  }
  
  NotificationService(){
    AwesomeNotifications().initialize(
      null,
      channels.values.toSet().toList(),
      debug: true
    );
  }
}