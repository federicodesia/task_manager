import 'package:flutter/material.dart';
import 'package:task_manager/bottom_sheets/modal_bottom_sheet.dart';
import 'package:task_manager/bottom_sheets/task_bottom_sheet.dart';
import 'package:task_manager/components/aligned_animated_switcher.dart';

import '../../constants.dart';

class AnimatedFloatingActionButtonScrollNotification extends StatelessWidget{
  final bool currentState;
  final Function(bool) onChange;
  final Widget child;

  AnimatedFloatingActionButtonScrollNotification({
    required this.currentState,
    required this.onChange,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scroll) {
        ScrollMetrics metrics = scroll.metrics;
 
        if(metrics.maxScrollExtent > 0){
          if(metrics.pixels >= metrics.maxScrollExtent){
            if(currentState) onChange(false);
          }
          else if(!currentState) onChange(true);
        }
        else if(!currentState) onChange(true);
        return true;
      },
      child: child,
    );
  }
}

class AnimatedFloatingActionButton extends StatelessWidget {

  final bool visible;
  AnimatedFloatingActionButton({this.visible = true});

  @override
  Widget build(BuildContext context) {
    return AlignedAnimatedSwitcher(
      alignment: Alignment.bottomRight,
      duration: Duration(milliseconds: 150),
      child: visible ? SizedBox(
        height: cButtonSize,
        width: cButtonSize,
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: cPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(cBorderRadius))
          ),
          child: Icon(Icons.add_rounded),
          onPressed: () {
            ModalBottomSheet(
              title: "Create a task",
              context: context,
              content: TaskBottomSheet(),
            ).show();
          },
          heroTag: null,
        ),
      ) : Container(),
    );
  }
}