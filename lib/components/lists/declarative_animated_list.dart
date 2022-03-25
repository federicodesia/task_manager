import 'package:declarative_animated_list/declarative_animated_list.dart';
// ignore: implementation_imports
import 'package:declarative_animated_list/src/algorithm/request.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';

class DeclarativeAnimatedList<T extends Object> extends StatelessWidget{
  
  // Make the removeBuilder parameter optional.
  
  final bool shrinkWrap;
  final ScrollPhysics physics;
  final Duration insertDuration;
  final Duration removeDuration;
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index, Animation<double> animation) itemBuilder;
  final Widget? Function(BuildContext context, T item, int index, Animation<double> animation)? removeBuilder;
  final EqualityCheck<T>? equalityCheck;
  final Axis scrollDirection;
  final bool reverse;
  
  const DeclarativeAnimatedList({
    Key? key, 
    this.shrinkWrap = true,
    this.physics = const NeverScrollableScrollPhysics(),
    this.insertDuration = cAnimatedListDuration,
    this.removeDuration = cAnimatedListDuration,
    required this.items,
    required this.itemBuilder,
    this.removeBuilder,
    this.equalityCheck,
    this.scrollDirection = Axis.vertical,
    this.reverse = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DeclarativeList(
      shrinkWrap: shrinkWrap,
      physics: physics,
      insertDuration: insertDuration,
      removeDuration: removeDuration,
      items: items,
      itemBuilder: itemBuilder,
      removeBuilder: (buildContext, T type, index, animation) {
        if(removeBuilder != null){
          final removeItem = removeBuilder!(buildContext, type, index, animation);
          if(removeItem != null) return removeItem;
        }
        return itemBuilder(buildContext, type, index, animation);
      },
      equalityCheck: equalityCheck,
      scrollDirection: scrollDirection,
      reverse: reverse,
    );
  }
}