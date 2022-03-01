import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';

class AnimatedWidgetSize extends StatelessWidget {
  final Duration duration;
  final Curve curve;
  final Alignment alignment;
  final Widget child;

  const AnimatedWidgetSize({
    Key? key, 
    this.duration = cTransitionDuration,
    this.curve = Curves.linear,
    this.alignment = Alignment.topLeft,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return AnimatedSize(
      duration: duration,
      curve: curve,
      alignment: alignment,
      child: child,
    );
  }
}