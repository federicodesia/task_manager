import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/app.dart';
import 'package:task_manager/blocs/drifted_bloc/drifted_bloc.dart';
import 'package:task_manager/blocs/drifted_bloc/drifted_storage.dart';
import 'package:task_manager/firebase_options.dart';
import 'package:task_manager/messaging/background_handler.dart';
import 'package:task_manager/services/locator_service.dart';

void main() async{
  Paint.enableDithering = true;
  setupLocator();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(BackgroundHandler.onBackgroundMessage);

  final storage = await DriftedStorage.build();
  DriftedBlocOverrides.runZoned(
    () => runApp(const MyApp()),
    storage: storage
  );
}