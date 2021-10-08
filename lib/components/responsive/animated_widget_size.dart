import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';

class AnimatedWidgetSize extends StatefulWidget {
  final Duration duration;
  final Curve curve;
  final Alignment alignment;
  final Widget child;

  AnimatedWidgetSize({
    this.duration = cTransitionDuration,
    this.curve = Curves.linear,
    this.alignment = Alignment.topLeft,
    this.child,
  });

  @override
  _AnimatedWidgetSizeState createState() => _AnimatedWidgetSizeState();
}

class _AnimatedWidgetSizeState extends State<AnimatedWidgetSize> with TickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
     return AnimatedSize(
      vsync: this,
      duration: widget.duration,
      curve: widget.curve,
      alignment: widget.alignment,
      child: widget.child,
    );
  }
}