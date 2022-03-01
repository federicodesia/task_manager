import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';

class AlignedAnimatedSwitcher extends StatefulWidget{

  final Widget child;
  final Alignment alignment;
  final Duration duration;

  const AlignedAnimatedSwitcher({
    Key? key, 
    required this.child,
    this.alignment = Alignment.topLeft,
    this.duration = cTransitionDuration
  }) : super(key: key);

  @override
  _AlignedAnimatedSwitcherState createState() => _AlignedAnimatedSwitcherState();
}

class _AlignedAnimatedSwitcherState extends State<AlignedAnimatedSwitcher>{

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: widget.duration,
      layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
        return Stack(
          children: <Widget>[
            ...previousChildren,
            if(currentChild != null) currentChild,
          ],
          alignment: widget.alignment,
        );
      },
      child: widget.child,
    );
  }
}