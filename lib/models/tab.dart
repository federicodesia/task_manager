import 'package:flutter/material.dart';

class MyTab{
  final String text;
  final Widget content;

  MyTab(this.text, this.content);
}

final List<MyTab> tabList = <MyTab>[
  MyTab("Today", Container()),
  MyTab("Tasks", Container()),
  MyTab("Reminders", Container()),
  MyTab("Notes", Container()),
];