import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/components/rounded_button.dart';

import '../constants.dart';

class TimePickerBottomSheet extends StatelessWidget{
  final Duration initialTime;
  final Function(Duration) onTimeChanged;

  TimePickerBottomSheet({
    this.onTimeChanged,
    this.initialTime
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
      data: CupertinoThemeData(
        brightness: Brightness.dark
      ),
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
              style: cSubtitleTextStyle,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      )
    );
  }
}