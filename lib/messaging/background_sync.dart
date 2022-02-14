import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_manager/blocs/category_bloc/category_bloc.dart';
import 'package:task_manager/blocs/sync_bloc/sync_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/repositories/base_repository.dart';
import 'package:task_manager/repositories/sync_repository.dart';

abstract class BackgroundSync{

  static Future<void> backgroundSyncHandler(RemoteMessage message) async{
    try{
      await Firebase.initializeApp();

      await HydratedStorage.build(
        storageDirectory: await getTemporaryDirectory(),
      ).then((storage){
        HydratedBlocOverrides.runZoned(
          (){
            final taskBloc = TaskBloc();
            SyncBloc(
              syncRepository: SyncRepository(base: BaseRepository()),
              taskBloc: taskBloc,
              categoryBloc: CategoryBloc(taskBloc: taskBloc)
            )..add(BackgroundSyncRequested());
          },
          storage: storage,
        );
      });
    }
    catch(_){}
  }
}