import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

class DateTimeSerializer implements JsonConverter<DateTime, String> {
  const DateTimeSerializer();

  @override
  DateTime fromJson(String dateUtc) => DateFormat("yyyy-MM-ddTHH:mm:ss.SSS").parse(dateUtc, true).toLocal();

  @override
  String toJson(DateTime localDate) => DateFormat("yyyy-MM-ddTHH:mm:ss.SSS").format(localDate.toUtc()) + "Z";
}

class NullableDateTimeSerializer implements JsonConverter<DateTime?, String?> {
  const NullableDateTimeSerializer();

  @override
  DateTime? fromJson(String? dateUtc) => dateUtc != null ? const DateTimeSerializer().fromJson(dateUtc) : null;

  @override
  String? toJson(DateTime? localDate) => localDate != null ? const DateTimeSerializer().toJson(localDate) : null;
}