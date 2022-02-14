import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_manager/app.dart';
import 'package:task_manager/firebase_options.dart';
import 'package:task_manager/messaging/background_sync.dart';
import 'package:task_manager/services/locator_service.dart';

void main() async{
  Paint.enableDithering = true;
  setupLocator();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(BackgroundSync.backgroundSyncHandler);

  await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  ).then((storage){
    HydratedBlocOverrides.runZoned(
      () => runApp(MyApp()),
      storage: storage,
    );
  });
}