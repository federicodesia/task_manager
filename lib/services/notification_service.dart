import 'dart:async';

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

  StreamSubscription<ReceivedNotification>? _displayedSubscription;
  final _displayedController = StreamController<ReceivedNotification>.broadcast();
  Stream<ReceivedNotification> get displayedStream => _displayedController.stream;
  
  NotificationService(){
    _init();
  }

  void _init() async {
    try{
      await AwesomeNotifications().initialize(
        null,
        channels.values.toSet().toList(),
        debug: true
      );

      _displayedSubscription = AwesomeNotifications().displayedStream.listen(
        (notification) => _displayedController.add(notification)
      );
    }
    catch(_){}
  }

  void close() async {
    try{
      await _displayedSubscription?.cancel();
      await _displayedController.close();
    }
    catch(_){}
  }
}