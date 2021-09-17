import 'package:flutter/material.dart';
import 'package:task_manager/bottom_sheets/task_bottom_sheet.dart';
import 'package:task_manager/models/tab.dart';
import 'package:task_manager/tabs/today_tab.dart';

List<MyTab> tabList = <MyTab>[
  MyTab(
    name: "Today",
    content: TodayTab(),
    createTitle: "Create a task",
    editTitle: "Edit task",
    bottomSheet: TaskBottomSheet()
  ),

  MyTab(
    name: "Tasks",
    content: Container(),
    createTitle: "",
    editTitle: "",
    bottomSheet: Container()
  ),

  MyTab(
    name: "Reminders",
    content: Container(),
    createTitle: "",
    editTitle: "",
    bottomSheet: Container()
  ),

  MyTab(
    name: "Notes",
    content: Container(),
    createTitle: "",
    editTitle: "",
    bottomSheet: Container()
  ),
];