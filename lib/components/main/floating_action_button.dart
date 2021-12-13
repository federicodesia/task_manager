import 'package:flutter/material.dart';
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
  final IconData icon;
  final void Function()? onPressed;

  AnimatedFloatingActionButton({
    this.visible = true,
    this.icon = Icons.add_rounded,
    this.onPressed
  });

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
          child: Icon(icon),
          onPressed: onPressed,
          heroTag: null,
        ),
      ) : Container(),
    );
  }
}