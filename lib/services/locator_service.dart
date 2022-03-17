import 'package:get_it/get_it.dart';
import 'package:task_manager/services/context_service.dart';
import 'package:task_manager/services/dialog_service.dart';
import 'package:task_manager/services/notification_service.dart';

GetIt locator = GetIt.instance;

void setupLocator(){
  locator.registerLazySingleton(() => (ContextService()));
  locator.registerLazySingleton(() => (DialogService()));
  locator.registerLazySingleton(() => (NotificationService()));
}
