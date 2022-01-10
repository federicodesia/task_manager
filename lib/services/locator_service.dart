import 'package:get_it/get_it.dart';
import 'package:task_manager/services/dialog_service.dart';

GetIt locator = GetIt.instance;

void setupLocator(){
  locator.registerLazySingleton(() => (DialogService()));
}
