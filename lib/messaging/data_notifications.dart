import 'package:firebase_messaging/firebase_messaging.dart';

enum DataNotificationType { newData, logout, newUserData, newSession }

extension RemoteMessageExtension on RemoteMessage {
  DataNotificationType? get dataNotificationType{
    final type = data["type"];
    
    if(type == "new-data") return DataNotificationType.newData;
    if(type == "logout") return DataNotificationType.logout;
    if(type == "new-user-data") return DataNotificationType.newUserData;
    if(type == "new-session") return DataNotificationType.newSession;
    return null;
  }
}