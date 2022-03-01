import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:task_manager/components/lists/declarative_animated_list.dart';
import 'package:task_manager/components/lists/list_item_animation.dart';
import 'package:task_manager/constants.dart';

class ShimmerList extends StatefulWidget{

  final Axis scrollDirection;
  final Duration delayDuration;
  final Duration animationDuration;
  final Duration lastItemDuration;
  final int minItems;
  final int maxItems;
  final Widget child;

  const ShimmerList({
    Key? key, 
    this.scrollDirection = Axis.vertical,
    this.delayDuration = const Duration(milliseconds: 250),
    this.animationDuration = cAnimatedListDuration,
    this.lastItemDuration = const Duration(milliseconds: 1500),
    this.minItems = 3,
    this.maxItems = 3,
    required this.child
  }) : super(key: key);

  @override
  _ShimmerListState createState() => _ShimmerListState();
}

class _ShimmerListState extends State<ShimmerList>{

  late int minItems = widget.minItems;
  late int maxItems = widget.maxItems;
  late bool generateRandom = widget.maxItems > widget.minItems;

  int currentItems = 0;
  bool disposed = false;

  @override
  void initState(){
    animate();
    super.initState();
  }

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }

  void animate() async{
    while(!disposed) {

      final int itemCount;
      if(generateRandom) {
        itemCount = minItems + Random().nextInt(maxItems + 1 - minItems);
      } else {
        itemCount = minItems;
      }

      for(int i = 0; i <= itemCount; i++){
        if(!disposed) setState(() => currentItems = i);
        await Future.delayed(widget.delayDuration);
      }

      await Future.delayed(widget.lastItemDuration);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DeclarativeAnimatedList(
      insertDuration: widget.animationDuration,
      removeDuration: widget.animationDuration,
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