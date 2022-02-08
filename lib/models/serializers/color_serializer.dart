import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class ColorSerializer implements JsonConverter<Color, int> {
  const ColorSerializer();

  @override
  Color fromJson(int value) => Color(value);

  @override
  int toJson(Color color) => color.value;
}