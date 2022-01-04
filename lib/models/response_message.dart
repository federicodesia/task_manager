import 'package:json_annotation/json_annotation.dart';

part 'response_message.g.dart';

@JsonSerializable()
class ResponseMessage{
  final String? key;
  final String? message;

  const ResponseMessage({ 
    required this.key,
    this.message,
  });

  factory ResponseMessage.fromJson(Map<String, dynamic> json) => _$ResponseMessageFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseMessageToJson(this);
}