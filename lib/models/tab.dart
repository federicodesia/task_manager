import 'package:flutter/material.dart';
import 'package:task_manager/bottom_sheets/task_bottom_sheet.dart';
import 'package:task_manager/screens/home/tabs/today_tab.dart';
import 'package:task_manager/screens/home/tabs/upcoming_tab.dart';

class MyTab{
  final String name;
  Widget content;
  final String createTitle;
  final String editTitle;
  final Widget bottomSheet;
  final bool floatingActionButton;

  MyTab({
    this.name,
    this.content,
    this.createTitle,
    this.editTitle,
    this.bottomSheet,
    this.floatingActionButton = false
  });
}

List<MyTab> tabList = <MyTab>[
  MyTab(
    name: "Today",
    content: TodayTab(),
    createTitle: "Create a task",
    editTitle: "Edit task",
    bottomSheet: TaskBottomSheet(),
    floatingActionButton: true
  ),

  MyTab(
    name: "Upcoming",
    content: UpcomingTab(),
    createTitle: "",
    editTitle: "",
    bottomSheet: Container()
  ),

  MyTab(
    name: "Previous",
    content: Container(),
    createTitle: "",
    editTitle: "",
    bottomSheet: Container()
  ),
];
