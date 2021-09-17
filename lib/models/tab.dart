import 'package:flutter/material.dart';

class MyTab{
  final String name;
  final Widget content;
  final String createTitle;
  final String editTitle;
  final Widget bottomSheet;

  MyTab({
    required this.name,
    required this.content,
    required this.createTitle,
    required this.editTitle,
    required this.bottomSheet
  });
}