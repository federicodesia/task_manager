import 'package:flutter/material.dart';

class Category{
  final String? uuid;
  final String name;
  final Color color;

  Category({
    required this.uuid,
    required this.name,
    required this.color
  });

  bool get isGeneral => uuid == null;

  Category copyWith({String? name, Color? color}){
    return Category(
      uuid: this.uuid,
      name: name ?? this.name,
      color: color ?? this.color
    );
  }
}