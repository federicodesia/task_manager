import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:task_manager/blocs/auth_bloc/auth_bloc.dart';
import 'package:task_manager/blocs/category_bloc/category_bloc.dart';
import 'package:task_manager/blocs/drifted_bloc/drifted_bloc.dart';
import 'package:task_manager/blocs/drifted_bloc/drifted_storage.dart';
import 'package:task_manager/blocs/notifications_cubit/notifications_cubit.dart';
import 'package:task_manager/blocs/settings_cubit/settings_cubit.dart';
import 'package:task_manager/blocs/sync_bloc/sync_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/messaging/messaging_helper.dart';
import 'package:task_manager/repositories/sync_repository.dart';
import 'package:task_manager/services/notification_service.dart';

abstract class BackgroundSync{

  static Future<void> backgroundSyncHandler(RemoteMessage message) async{
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

          final taskBloc = TaskBloc(
            inBackground: true,
            authBloc: authBloc,
            notificationsCubit: notificationsCubit
          );

          final categoryBloc = CategoryBloc(
            inBackground: true,
            authBloc: authBloc,
            taskBloc: taskBloc
          );

          final syncBloc = SyncBloc(
            inBackground: true,
            authBloc: authBloc,
            taskBloc: taskBloc,
            categoryBloc: categoryBloc,
            syncRepository: SyncRepository(
              base: authBloc.baseRepository
            ),
          );
          
          syncBloc.add(BackgroundSyncRequested());

          MessagingHelper.autoCloseBlocs(
            blocs: [
              settingsCubit,
              authBloc,
              notificationsCubit,
              taskBloc,
              categoryBloc,
              syncBloc
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