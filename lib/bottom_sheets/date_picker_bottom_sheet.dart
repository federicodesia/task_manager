import 'package:flutter/material.dart';
import 'package:task_manager/components/rounded_button.dart';

import '../constants.dart';

class DatePickerBottomSheet extends StatelessWidget{

  final DateTime initialDate;
  final ValueChanged<DateTime> onDateChanged;

  DatePickerBottomSheet({
    this.onDateChanged,
    this.initialDate
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: cPrimaryColor,
          surface: cBackgroundColor,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: cPadding),
            child: CalendarDatePicker(
              initialDate: initialDate,
              firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
              lastDate: DateTime.now().add(Duration(days: 365)),
              onDateChanged: onDateChanged
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