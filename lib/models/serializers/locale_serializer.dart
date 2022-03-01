import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class LocaleSerializer implements JsonConverter<Locale?, String?> {
  const LocaleSerializer();

  @override
  Locale? fromJson(String? languageCode) => languageCode != null ? Locale(languageCode) : null;

  @override
  String? toJson(Locale? locale) => locale?.languageCode;
}