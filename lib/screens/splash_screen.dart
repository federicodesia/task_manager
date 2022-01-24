import 'package:flutter/material.dart';
import 'package:task_manager/theme/theme.dart';

class SplashScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;

    return Scaffold(
      backgroundColor: customTheme.backgroundColor,
      body: SafeArea(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}