import 'package:flutter/material.dart';
import 'package:task_manager/components/aligned_animated_switcher.dart';

import '../../constants.dart';

class AnimatedFloatingActionButtonScrollNotification extends StatefulWidget{
  final bool currentState;
  final Function(bool) onChange;
  final Widget child;

  AnimatedFloatingActionButtonScrollNotification({
    required this.currentState,
    required this.onChange,
    required this.child,
  });

  @override
  State<AnimatedFloatingActionButtonScrollNotification> createState() => _AnimatedFloatingActionButtonScrollNotificationState();
}

class _AnimatedFloatingActionButtonScrollNotificationState extends State<AnimatedFloatingActionButtonScrollNotification> {
  ScrollMetricsNotification? lastNotification;

  void updateState(ScrollMetrics metrics){
    if(metrics.axis == Axis.vertical){
      if(metrics.maxScrollExtent > 0){
        if(metrics.pixels >= metrics.maxScrollExtent){
          if(widget.currentState) widget.onChange(false);
        }
        else if(!widget.currentState) widget.onChange(true);
      }
      else if(!widget.currentState) widget.onChange(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollMetricsNotification>(
      onNotification: (ScrollMetricsNotification notification){
        lastNotification = notification;

        Future.delayed(Duration(), (){
          if(lastNotification == notification) updateState(notification.metrics);
        });
        
        return false;
      },
      child: widget.child,
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
      duration: cFastAnimationDuration,
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