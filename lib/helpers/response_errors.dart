import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:task_manager/helpers/response_messages.dart';
import 'package:task_manager/services/dialog_service.dart';
import 'package:task_manager/services/locator_service.dart';

abstract class ResponseError{

  static Future<ResponseMessage?> validate(
    Object error,
    List<String>? ignoreKeys,
    {bool Function(String)? ignoreFunction}
  ) async{

    final connectivityResult = await Connectivity().checkConnectivity();
    if(connectivityResult == ConnectivityResult.none){
      locator<DialogService>().showNoInternetConnectionDialog();
      return null;
    }

    if(error is DioError){
      try{
        final responseMessages = ResponseMessage(error.response?.data["message"]);
        if(ignoreKeys != null && ignoreKeys.any((key) => responseMessages.contains(key))) return responseMessages;
        if(ignoreFunction != null && responseMessages.checkFunction(ignoreFunction)) return responseMessages;
      }
      // ignore: empty_catches
      catch(error){}
    }
    
    locator<DialogService>().showSomethingWentWrongDialog();
    return null;
  }
}