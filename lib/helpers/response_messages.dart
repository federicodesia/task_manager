import 'package:collection/collection.dart';

class ResponseMessage{
  List<String> _messageList = [];

  final dynamic responseMessage;
  ResponseMessage(this.responseMessage){

    if(responseMessage is List<dynamic>){
      _messageList = responseMessage
        .where((m) => m is String)
        .map((m) => (m as String).toLowerCase())
        .toList();
    }
    else if(responseMessage is String){
      _messageList = [(responseMessage as String).toLowerCase()];
    }
  }

  String get first => _messageList.firstOrNull ?? "Unexpected error";

  bool contains(String key) => _messageList.any((m) => m.contains(key.toLowerCase()));

  String? get(String key) => _messageList.firstWhereOrNull((m) => m.contains(key.toLowerCase()));

  bool checkFunction(bool Function(String) function) => _messageList.any((m) => function(m));
}