import 'package:flutter/material.dart';
import 'package:task_manager/bottom_sheets/modal_bottom_sheet.dart';
import 'package:task_manager/components/rounded_button.dart';
import 'package:task_manager/l10n/l10n.dart';

import '../constants.dart';

class DatePickerBottomSheet{

  final BuildContext context;
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateChanged;

  DatePickerBottomSheet(
    this.context,
    {
      required this.initialDate,
      required this.onDateChanged
    }
  );

  void show(){
    ModalBottomSheet(
      title: context.l10n.bottomSheet_selectDate,
      context: context,
      content: _DatePickerBottomSheet(this)
    ).show();
  }
}

class _DatePickerBottomSheet extends StatelessWidget{

  final DatePickerBottomSheet data;
  const _DatePickerBottomSheet(this.data);

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: cPadding),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: cPadding),
            child: CalendarDatePicker(
              initialDate: data.initialDate,
              firstDate: DateTime(1969, 1, 1),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              onDateChanged: data.onDateChanged
            ),
          ),
          RoundedTextButton(
            text: context.l10n.select_button,
            onPressed: () => Navigator.of(context).pop()
          )
        ],
      ),
    );
  }
}