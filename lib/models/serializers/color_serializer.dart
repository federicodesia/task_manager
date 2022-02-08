import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class ColorSerializer implements JsonConverter<Color, String> {
  const ColorSerializer();

  @override
  Color fromJson(String value){
    try{
      return Color(int.parse(value));
    }
    catch(_) {}
    return Colors.grey.withOpacity(0.65);
  }

  @override
  String toJson(Color color) => color.value.toString();
}