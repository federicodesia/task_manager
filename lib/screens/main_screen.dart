import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/components/main/bottom_navigation_bar.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/router/router.gr.dart';
import 'package:task_manager/theme/theme.dart';

class MainScreen extends StatelessWidget{
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;
    
    return AutoTabsScaffold(
      backgroundColor: customTheme.backgroundColor,

      animationDuration: cTransitionDuration,
      builder: (context, child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SafeArea(
            child: child
          )
        );
      },

      homeIndex: 0,
      routes: const [
        HomeRoute(),
        CalendarRoute(),
        NotificationsRoute(),
        SettingsRoute()
      ],
      bottomNavigationBuilder: (_, tabsRouter) {

        return MyBottomNavigationBar(
          tabsRouter: tabsRouter,
          icons: const [
            Icons.home_rounded,
            Icons.event_note_rounded,
            Icons.notifications_rounded,
            Icons.settings_rounded,
          ],
        );
      },
    );
  }
}