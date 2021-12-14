import 'dart:async';

import 'package:flutter/material.dart';
import 'package:task_manager/components/lists/declarative_animated_list.dart';
import 'package:task_manager/components/lists/list_item_animation.dart';
import 'package:task_manager/constants.dart';

class ShimmerList extends StatefulWidget{

  final Axis scrollDirection;
  final Duration delayDuration;
  final Duration animationDuration;
  final int itemCount;
  final Widget child;

  const ShimmerList({
    this.scrollDirection = Axis.vertical,
    this.delayDuration = const Duration(milliseconds: 250),
    this.animationDuration = cAnimatedListDuration,
    this.itemCount = 3,
    required this.child
  });

  @override
  _ShimmerListState createState() => _ShimmerListState();
}

class _ShimmerListState extends State<ShimmerList>{

  late Duration delayDuration = widget.delayDuration;
  late Duration animationDuration = widget.animationDuration;
  late int itemCount = widget.itemCount;

  late Timer timer;
  late int currentItems;
  bool disposed = false;

  @override
  void initState() {
    final Duration timerDuration = animationDuration * itemCount + delayDuration;

    animate();
    Future.delayed(timerDuration - (delayDuration * itemCount), () {
      timer = Timer.periodic(timerDuration, (_) => animate());
    });
    
    super.initState();
  }

  void animate() async{
    for(int i = 0; i <= itemCount; i++){
      if(!disposed) setState(() => currentItems = i);
      await Future.delayed(delayDuration);
    }
  }

  @override
  void dispose() {
    disposed = true;
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DeclarativeAnimatedList(
      insertDuration: animationDuration,
      removeDuration: animationDuration,
      reverse: true,
      scrollDirection: widget.scrollDirection,
      items: List.generate(currentItems, (index) => widget.child),
      itemBuilder: (context, item, index, animation){
        return ListItemAnimation(
          animation: animation,
          axis: Axis.horizontal,
          child: widget.child
        );
      },
    );
  }
}