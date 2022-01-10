import 'package:collection/collection.dart';

List<String> generateResponseMessage(dynamic message){
  if(message is List<dynamic>) return message.where((m) => m is String).map((m) => m as String).toList();
  if(message is String) return [message];
  return [];
}

String? getResponseMessage(List<String> messages, {String? key}){
  if(key != null) return messages.firstWhereOrNull((m) => m.toLowerCase().contains(key.toLowerCase()));
  else return messages.firstOrNull;
}