import 'package:flutter/material.dart';
import 'package:task_manager/bottom_sheets/modal_bottom_sheet.dart';
import 'package:task_manager/tabs/tabs.dart';

import '../../constants.dart';

class MyFloatingActionButton extends StatelessWidget {

  final int currentTab;
  final BuildContext buildContext;
  
  MyFloatingActionButton({
    this.currentTab,
    this.buildContext
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
        child: Icon(
          Icons.add_rounded,
        ),
        onPressed: () {
          ModalBottomSheet(
            title: tabList[currentTab].createTitle,
            context: buildContext,
            content: tabList[currentTab].bottomSheet,
          ).show();
        },
      ),
    );
  }
}