import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:task_manager/helpers/response_messages.dart';
import 'package:task_manager/services/dialog_service.dart';
import 'package:task_manager/services/locator_service.dart';

Future<List<String>?> onResponseError({
  required Object error,
  List<String>? messageKeys
}) async{

  final connectivityResult = await Connectivity().checkConnectivity();
  if(connectivityResult == ConnectivityResult.none){
    locator<DialogService>().showNoInternetConnectionDialog();
    return null;
  }

  if(error is DioError){
    final responseMessages = generateResponseMessage(error.response?.data["message"]);
    if(messageKeys == null || (responseMessages.any((m) => messageKeys.any((k) => m.contains(k))))
    ) return responseMessages;
  }
  
  locator<DialogService>().showSomethingWentWrongDialog();
  return null;
}