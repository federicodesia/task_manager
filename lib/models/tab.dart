import 'package:flutter/material.dart';

class MyTab{
  final String name;
  final Widget content;
  final String createTitle;
  final String editTitle;
  final Widget bottomSheet;

  MyTab({
    this.name,
    this.content,
    this.createTitle,
    this.editTitle,
    this.bottomSheet
  });
}