import 'package:flutter/material.dart';
import 'package:task_manager/screens/home/tabs/today_tab.dart';
import 'package:task_manager/screens/home/tabs/upcoming_tab.dart';

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

List<MyTab> tabList = <MyTab>[
  MyTab(
    name: "Today",
    content: TodayTab(),
    floatingActionButton: true
  ),

  MyTab(
    name: "Upcoming",
    content: UpcomingTab(),
  ),

  MyTab(
    name: "Previous",
    content: Container(),
  ),
];
