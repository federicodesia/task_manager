import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/components/main/bottom_navigation_bar.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/router/router.gr.dart';

class MainScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      backgroundColor: cBackgroundColor,
      builder: (context, child, animation) {
        return SafeArea(child: child);
      },

      homeIndex: 0,
      routes: [
        HomeRoute(),
        SettingsRoute(),
        SettingsRoute(),
        SettingsRoute()
      ],
      bottomNavigationBuilder: (_, tabsRouter) {

        return MyBottomNavigationBar(
          tabsRouter: tabsRouter,
          items: [
            MyBottomNavigationBarItem(
              icon: "home_outlined.png",
              selectedIcon: "home_filled.png"
            ),

            MyBottomNavigationBarItem(
              icon: "calendar_outlined.png",
              selectedIcon: "calendar_filled.png"
            ),

            MyBottomNavigationBarItem(
              icon: "notification_outlined.png",
              selectedIcon: "notification_filled.png"
            ),

            MyBottomNavigationBarItem(
              icon: "settings_outlined.png",
              selectedIcon: "settings_filled.png"
            ),
          ],
        );
      },
    );
  }
}