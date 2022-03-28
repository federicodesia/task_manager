import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:task_manager/messaging/data_notifications.dart';
import 'package:task_manager/messaging/types/background_auth.dart';
import 'package:task_manager/messaging/types/background_sync.dart';

abstract class BackgroundHandler{

  static Future<void> onBackgroundMessage(RemoteMessage message) async{
    try{
      await Firebase.initializeApp();
      final type = message.dataNotificationType;
      if(type == null) return;

      if(type == DataNotificationType.newData){
        BackgroundSync.backgroundSyncHandler(message);
      }
      else if(type == DataNotificationType.logout
        || type == DataNotificationType.newUserData
        || type == DataNotificationType.newUserData
      ){
        BackgroundAuth.backgroundAuthHandler(message, type);
      }
    }
    catch(_){}
  }
}