import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/theme/theme.dart';

import '../constants.dart';

class TimePickerBottomSheet extends StatelessWidget{
  final Duration initialTime;
  final Function(Duration) onTimeChanged;

  TimePickerBottomSheet({
    required this.onTimeChanged,
    required this.initialTime
  });

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;
    
    return CupertinoTheme(
      data: CupertinoThemeData(
        brightness: Brightness.dark
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: cPadding),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: cPadding),
              child: CupertinoTimerPicker(
                mode: CupertinoTimerPickerMode.hm,
                initialTimerDuration: initialTime,
                onTimerDurationChanged: onTimeChanged
              ),
            ),
            RoundedButton(
              width: double.infinity,
              child: Text(
                "Select",
                style: customTheme.boldTextStyle,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      )
    );
  }
}