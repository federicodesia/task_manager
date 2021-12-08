import 'package:flutter/material.dart';

class MyTab{
  final String name;
  Widget content;
  final bool floatingActionButton;

  MyTab({
    required this.name,
    required this.content,
    this.floatingActionButton = false
  });
}