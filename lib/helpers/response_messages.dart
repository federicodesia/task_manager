import 'package:task_manager/models/response_message.dart';
import 'package:collection/collection.dart';

class ResponseMessages{

  from(dynamic message, {required List<String> keys}){

    final List<ResponseMessage> responseMessages = [];

    if(message is List<dynamic>){
      keys.forEach((key) {
        responseMessages.add(ResponseMessage(
          key: key,
          message: message.firstWhereOrNull((m) => m is String && m.toLowerCase().contains(key.toLowerCase()))
        ));
      });
    }
    else if(message is String){
      responseMessages.add(ResponseMessage(
        key: keys.firstWhereOrNull((k) => message.toLowerCase().contains(k.toLowerCase())),
        message: message
      ));
    }

    return responseMessages;
  }
}