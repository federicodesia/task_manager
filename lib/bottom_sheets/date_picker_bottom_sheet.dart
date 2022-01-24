import 'package:flutter/material.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/helpers/date_time_helper.dart';
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
      child: Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.dark(
            primary: cPrimaryColor,
            surface: customTheme.backgroundColor,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: cPadding),
              child: CalendarDatePicker(
                initialDate: initialDate,
                firstDate: getDate(DateTime.now()),
                lastDate: DateTime.now().add(Duration(days: 365)),
                onDateChanged: onDateChanged
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
        )
      ),
    );
  }
}