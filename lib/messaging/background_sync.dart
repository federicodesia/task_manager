import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/category_bloc/category_bloc.dart';
import 'package:task_manager/blocs/drifted_bloc/drifted_bloc.dart';
import 'package:task_manager/blocs/drifted_bloc/drifted_storage.dart';
import 'package:task_manager/blocs/notifications_cubit/notifications_cubit.dart';
import 'package:task_manager/blocs/settings_cubit/settings_cubit.dart';
import 'package:task_manager/blocs/sync_bloc/sync_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/repositories/base_repository.dart';
import 'package:task_manager/repositories/sync_repository.dart';
import 'package:task_manager/services/notification_service.dart';

abstract class BackgroundSync{

  static Future<void> backgroundSyncHandler(RemoteMessage message) async{
    try{
      await Firebase.initializeApp();

      final storage = await DriftedStorage.build();
      DriftedBlocOverrides.runZoned(
        () async {

          final settingsCubit = SettingsCubit();


          final notificationService = NotificationService();
          final notificationsCubit = NotificationsCubit(
            notificationService: notificationService,
            settingsCubit: settingsCubit
          );
          
          final taskBloc = TaskBloc(notificationsCubit: notificationsCubit);
          final categoryBloc = CategoryBloc(taskBloc: taskBloc);

          final syncBloc = SyncBloc(
            syncRepository: SyncRepository(base: BaseRepository()),
            taskBloc: taskBloc,
            categoryBloc: categoryBloc
          );
          
          syncBloc.add(HighPrioritySyncRequested());

          _autoCloseBlocs(
            blocs: [
              settingsCubit,
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

  static void _autoCloseBlocs({
    required List<BlocBase> blocs,
    Function()? onClosed
  }) async {
    await Future.any(
      blocs.map((bloc) => bloc.stream.first)
    )
    .timeout(const Duration(seconds: 10), onTimeout: () {
      throw TimeoutException("BackgroundSync | Timeout");
    })
    .then((_){
      _autoCloseBlocs(
        blocs: blocs,
        onClosed: onClosed
      );
    })
    .onError((error, _) {
      if(error is TimeoutException)  {
        debugPrint("BackgroundSync | Closing all blocs...");
        
        for (BlocBase bloc in blocs) {
          bloc.close();
        }
        if(onClosed != null) onClosed();
      }
    });
  }
}