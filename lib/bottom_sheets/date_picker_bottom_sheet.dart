import 'package:flutter/material.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/l10n/l10n.dart';
import 'package:task_manager/theme/theme.dart';

import '../constants.dart';

class DatePickerBottomSheet extends StatelessWidget{

  final DateTime initialDate;
  final ValueChanged<DateTime> onDateChanged;

  DatePickerBottomSheet({
    required this.onDateChanged,
    required this.initialDate
  });

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: cPadding),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: cPadding),
            child: CalendarDatePicker(
              initialDate: initialDate,
              firstDate: DateTime(1969, 1, 1),
              lastDate: DateTime.now().add(Duration(days: 365)),
              onDateChanged: onDateChanged
            ),
          ),
          RoundedButton(
            width: double.infinity,
            child: Text(
              context.l10n.select_button,
              style: customTheme.primaryColorButtonTextStyle,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}