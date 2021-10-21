import 'package:flutter/material.dart';
import 'package:task_manager/screens/home/home_screen.dart';

class MyBottomNavigationBarItem{
  final String icon;
  final String selectedIcon;
  final Widget child;

  MyBottomNavigationBarItem({
    this.icon,
    this.selectedIcon,
    this.child
  });
}

List<MyBottomNavigationBarItem> bottomNavigationBarItems = [
  MyBottomNavigationBarItem(
    icon: "home_outlined",
    selectedIcon: "home_filled",
    child: HomeScreen()
  ),

  MyBottomNavigationBarItem(
    icon: "calendar_outlined",
    selectedIcon: "calendar_filled",
    child: Container()
  ),

  MyBottomNavigationBarItem(
    icon: "notification_outlined",
    selectedIcon: "notification_filled",
    child: Container()
  ),

  MyBottomNavigationBarItem(
    icon: "settings_outlined",
    selectedIcon: "settings_filled",
    child: Container()
  )
];