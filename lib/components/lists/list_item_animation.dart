import 'package:flutter/material.dart';

class ListItemAnimation extends StatelessWidget{
  
  final Animation<double> animation;
  final Widget child;

  ListItemAnimation({
    required this.animation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animation,
          curve: Interval(0.75, 1.0, curve: Curves.easeInOut),
        ),
      ),
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: animation,
          curve: Curves.fastOutSlowIn
        ),
        child: child,
      )
    );
  }
}