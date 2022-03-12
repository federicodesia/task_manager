import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:task_manager/blocs/category_bloc/category_bloc.dart';
import 'package:task_manager/blocs/drifted_bloc/drifted_bloc.dart';
import 'package:task_manager/blocs/drifted_bloc/drifted_storage.dart';
import 'package:task_manager/blocs/sync_bloc/sync_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/repositories/base_repository.dart';
import 'package:task_manager/repositories/sync_repository.dart';

abstract class BackgroundSync{

  static Future<void> backgroundSyncHandler(RemoteMessage message) async{
    try{
      await Firebase.initializeApp();

      final storage = await DriftedStorage.build();
      DriftedBlocOverrides.runZoned(
        () async {
          final taskBloc = TaskBloc();
          final syncBloc = SyncBloc(
            syncRepository: SyncRepository(base: BaseRepository()),
            taskBloc: taskBloc,
            categoryBloc: CategoryBloc(taskBloc: taskBloc)
          );

          await Future.delayed(const Duration(seconds: 1));
          syncBloc.add(HighPrioritySyncRequested());
        },
        storage: storage
      );
    }
    catch(_){}
  }
}