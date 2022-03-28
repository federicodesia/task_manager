import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/blocs/drifted_bloc/drifted_bloc.dart';
import 'package:task_manager/blocs/drifted_bloc/drifted_storage.dart';
import 'package:task_manager/blocs/notifications_cubit/notifications_cubit.dart';
import 'package:task_manager/blocs/settings_cubit/settings_cubit.dart';
import 'package:task_manager/messaging/data_notifications.dart';
import 'package:task_manager/messaging/messaging_helper.dart';
import 'package:task_manager/services/notification_service.dart';

abstract class BackgroundAuth{

  static void backgroundAuthHandler(
    RemoteMessage message,
    DataNotificationType dataNotificationType,
  ) async{
    
    try{
      final storage = await DriftedStorage.build();
      DriftedBlocOverrides.runZoned(
        () async {

          final settingsCubit = SettingsCubit();

          final notificationService = NotificationService();
          final notificationsCubit = NotificationsCubit(
            notificationService: notificationService,
            settingsCubit: settingsCubit
          );

          final authBloc = AuthBloc(notificationsCubit: notificationsCubit);
          authBloc.add(DataNotificationReceived(dataNotificationType));

          MessagingHelper.autoCloseBlocs(
            blocs: [
              settingsCubit,
              authBloc,
              notificationsCubit
            ],
            onClosed: (){
              notificationService.close();
            }
          );
        },
        storage: storage
      );
    }
    catch(_){}
  }
}