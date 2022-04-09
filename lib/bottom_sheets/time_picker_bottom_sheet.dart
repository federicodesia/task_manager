import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/bottom_sheets/modal_bottom_sheet.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/l10n/l10n.dart';
import 'package:task_manager/theme/theme.dart';

import '../constants.dart';

class TimePickerBottomSheet{

  final BuildContext context;
  final Duration initialTime;
  final Function(Duration) onTimeChanged;

  TimePickerBottomSheet(
    this.context,
    {
      required this.initialTime,
      required this.onTimeChanged
    }
  );

  void show(){
    ModalBottomSheet(
      title: context.l10n.bottomSheet_selectTime,
      context: context,
      content: _TimePickerBottomSheet(this)
    ).show();
  }
}

class _TimePickerBottomSheet extends StatelessWidget{
  
  final TimePickerBottomSheet data;
  const _TimePickerBottomSheet(this.data);

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;
    
    return CupertinoTheme(
      data: CupertinoThemeData(
        brightness: customTheme.isDark ? Brightness.dark : Brightness.light,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: cPadding),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: cPadding),
              child: CupertinoTimerPicker(
                mode: CupertinoTimerPickerMode.hm,
                initialTimerDuration: data.initialTime,
                onTimerDurationChanged: data.onTimeChanged
              ),
            ),
            RoundedTextButton(
              text: context.l10n.select_button,
              onPressed: () => Navigator.of(context).pop()
            )
          ],
        ),
      )
    );
  }
}