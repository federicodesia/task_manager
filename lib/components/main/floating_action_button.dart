import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/blocs/task_bloc/task_bloc.dart';
import 'package:task_manager/components/aligned_animated_switcher.dart';
import 'package:task_manager/theme/theme.dart';

import '../../constants.dart';

class AnimatedFloatingActionButtonScrollNotification extends StatefulWidget{
  final bool currentState;
  final Function(bool) onChange;
  final Widget child;

  const AnimatedFloatingActionButtonScrollNotification({
    Key? key, 
    required this.currentState,
    required this.onChange,
    required this.child,
  }) : super(key: key);

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
        else if(!widget.currentState) {
          widget.onChange(true);
        }
      }
      else if(!widget.currentState) {
        widget.onChange(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollMetricsNotification>(
      onNotification: (ScrollMetricsNotification notification){
        lastNotification = notification;

        Future.delayed(const Duration(), (){
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

  const AnimatedFloatingActionButton({
    Key? key, 
    this.visible = true,
    this.icon = Icons.add_rounded,
    this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).customTheme;
    
    return AlignedAnimatedSwitcher(
      alignment: Alignment.bottomRight,
      duration: cFastAnimationDuration,
      child: visible ? SizedBox(
        height: cButtonSize,
        width: cButtonSize,
        child: FloatingActionButton(
          elevation: customTheme.isDark ? 0.0 : 2.0,
          splashColor: customTheme.shadowColor,
          
          backgroundColor: cPrimaryColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(cBorderRadius))
          ),
          child: Icon(icon, color: Colors.white),
          onPressed: onPressed,
          heroTag: null,
        ),
      ) : Container(),
    );
  }
}

class TaskFloatingActionButton extends StatelessWidget {

  final bool visible;
  final void Function()? onPressed;

  const TaskFloatingActionButton({
    Key? key, 
    this.visible = true,
    this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (_, state) {
        return AnimatedFloatingActionButton(
          visible: !state.isLoading && visible,
          onPressed: onPressed,
        );
      }
    );
  }
}