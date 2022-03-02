import 'package:collection/collection.dart';

class ResponseMessage{
  List<String> _messageList = [];

  final int? statusCode;
  final dynamic responseMessage;
  ResponseMessage({
    required this.responseMessage,
    required this.statusCode
  }){

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

  String? getIgnoring(String key, {required String ignore}) =>
    _messageList.firstWhereOrNull((m) => m.contains(key.toLowerCase()) && !m.contains(ignore.toLowerCase()));

  bool checkFunction(bool Function(String) function) => _messageList.any((m) => function(m));

  bool containsAnyStatusCodes(List<int> statusCodes) => statusCodes.any((s) => statusCode == s);
}