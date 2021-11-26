import 'package:flutter/material.dart';
import 'package:task_manager/bottom_sheets/modal_bottom_sheet.dart';
import 'package:task_manager/bottom_sheets/task_bottom_sheet.dart';

import '../../constants.dart';

class MyFloatingActionButton extends StatelessWidget {

  final int currentTab;
  final IconData icon;
  
  MyFloatingActionButton({
    required this.currentTab,
    this.icon = Icons.add_rounded
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: cButtonSize,
      width: cButtonSize,
      child: FloatingActionButton(
        elevation: 0,
        backgroundColor: cPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(cBorderRadius))
        ),
        child: Icon(icon),
        onPressed: () {
          ModalBottomSheet(
            title: "Create a task",
            context: context,
            content: TaskBottomSheet(),
          ).show();
        },
      ),
    );
  }
}