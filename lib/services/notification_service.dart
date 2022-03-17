import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/helpers/string_helper.dart';
import 'package:task_manager/models/notification_type.dart';

class NotificationService{

  Map<NotificationType, NotificationChannel> channels = {
    for (var t in NotificationType.values) t : NotificationChannel(
      channelKey: t.name.toLowerSnakeCase,
      channelName: "${t.name.capitalize} notifications",
      channelDescription: "Description not provided",
      defaultColor: cPrimaryColor
    )
  };
  
  NotificationService(){
    AwesomeNotifications().initialize(
      null,
      channels.values.toList(),
      debug: true
    );
  }
}