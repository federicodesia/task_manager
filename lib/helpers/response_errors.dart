import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:task_manager/helpers/response_messages.dart';
import 'package:task_manager/services/dialog_service.dart';
import 'package:task_manager/services/locator_service.dart';

abstract class ResponseError{

  static Future<ResponseMessage?> validate(
    Object error,
    List<String>? ignoreKeys,
    {
      bool Function(String)? ignoreFunction
    }
  ) async{

    final connectivityResult = await Connectivity().checkConnectivity();
    if(connectivityResult == ConnectivityResult.none){
      try{
        locator<DialogService>().showNoInternetConnectionDialog();
      }
      catch(_){}
      return null;
    }

    if(error is DioError){
      try{
        final statusCode = error.response?.statusCode;
        if(statusCode == 401 || statusCode == 403) return null;

        final responseMessages = ResponseMessage(
          statusCode: statusCode,
          responseMessage: error.response?.data["message"]
        );
        
        if(ignoreKeys != null && ignoreKeys.any((key) => responseMessages.contains(key))) return responseMessages;
        if(ignoreFunction != null && responseMessages.checkFunction(ignoreFunction)) return responseMessages;
      }
      catch(_){}
    }
    
    try{
      locator<DialogService>().showSomethingWentWrongDialog();
    }
    catch(_){}
    return null;
  }
}